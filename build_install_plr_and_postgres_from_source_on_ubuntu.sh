#!/bin/bash
set -x -v -e

if [ ! -f "${GITHUB_ENV}" ]; then touch discard.txt; export GITHUB_ENV=discard.txt; fi


if [ "${R_HOME}" == "" ];    then echo "Environment variable R_HOME is missing."   ; exit 99; fi
if [ "${PG_SOURCE}" == "" ]; then echo "Environment variable PG_SOURCE is missing."; exit 99; fi

# Outputs
# PG_PATHS
# PostgreSQL is installed and started

#### # r-base-dev and r-base
#### # Ubuntu Packages For R - Full Instructions
#### # 
#### # 26.05 (“resolute”, amd64 and arm64),
#### # 24.04 (“noble”, amd64 and arm64),
#### # 22.04 (“jammy”, amd64 and arm64)
#### # complete R system - r-base
#### # need to compile R packages from source - r-base-dev
#### # https://cran.r-project.org/bin/linux/ubuntu/fullREADME.html
#### sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
#### 
#### # remote .deb package or an uninstalled package in your repository
#### #
#### # view the full control information, including the Depends line
#### apt-cache show r-base-dev
#### #
#### # see a structured list of direct dependencies and pre-dependencies
#### apt-cache depends r-base-dev
#### #
#### 
#### 
#### # # package.deb file
#### # # (or dpkg -I)
#### #
#### # # inspect the package metadata and read the Depends: field
#### # dpkg-deb -I <path-to-package.deb>
#### # # print only the depends-on line
#### # dpkg-deb -f <path-to-package.deb>
#### 
#### 
#### # view the full metadata of the installed package (including "Depends:" line)
#### apt show r-base-dev
#### 
#### # find the packages that an installed Ubuntu package depends on
#### apt depends r-base-dev
#### 
#### # installed package
#### #
#### # query the local package database directly without touching the network
#### # dpkg -s r-base-dev | grep '^Depends:'
#### 
#### # recursive list (the dependencies of the dependencies, all the way down),
#### sudo apt-get -qq install apt-rdepends -y
#### apt-rdepends r-base-dev
#### 

# # recursively list all dependent packages down the chain
# apt-rdepends r-base-dev

# provides to PostgreSQL package libreadline-dev
# sudo apt-get install -qq r-base-dev -y
sudo apt-get install -qq libreadline-dev -y

sudo apt-get install -qq bison flex libssl-dev -y

# PG PREPARE for "meson ( buildpgANDplrInSRCcontrib == 'true' )"
#
cat _meson_options.txt_postgres_root_additional_plr_option.txt
cat ${PG_SOURCE}/meson_options.txt | tail
cat _meson_options.txt_postgres_root_additional_plr_option.txt >> ${PG_SOURCE}/meson_options.txt
cat ${PG_SOURCE}/meson_options.txt | tail

cat ${PG_SOURCE}/contrib/meson.build | tail
echo 'subdir('"'"'plr'"'"')'                                   >>             ${PG_SOURCE}/contrib/meson.build
cat ${PG_SOURCE}/contrib/meson.build | tail
# R library
cat /usr/lib/pkgconfig/libR.pc

# PL/R PREPARE for "meson ( buildpgANDplrInSRCcontrib == 'true' )"
#
sudo mkdir      ${PG_SOURCE}/contrib/plr
sudo chmod 777  ${PG_SOURCE}/contrib/plr
cp -R *         ${PG_SOURCE}/contrib/plr/
ls -alrt        ${PG_SOURCE}/contrib/plr

pushd  ${PG_SOURCE}

# PREPARE FOR ( make )
#
# ./configure
# # six minutes
# make
# sudo make install


# one minute and four seconds
#
# https://mesonbuild.com/Quick-guide.html
sudo apt-get install -qq python3 ninja-build meson -y

meson setup -Dbuildtype=release -Db_pie=true -DR_HOME=${R_HOME} -Dnls=disabled -Dplperl=disabled -Dplpython=disabled -Dpltcl=disabled -Dicu=disabled -Dllvm=disabled -Dlz4=disabled -Dzstd=disabled -Dgssapi=disabled -Dldap=disabled -Dpam=disabled -Dbsd_auth=disabled -Dsystemd=disabled -Dbonjour=disabled -Dlibxml=disabled -Dlibxslt=disabled -Dreadline=enabled -Dzlib=disabled -Ddocs=disabled -Ddocs_pdf=disabled -Dcassert=false -Dtap_tests=disabled -Db_coverage=false -Ddtrace=disabled build

meson compile -C build -v

sudo meson install -C build

export PG_PATHS="/usr/local/pgsql/bin"
echo "PG_PATHS=${PG_PATHS}" > ${GITHUB_ENV}
echo "PG_PATHS: ${PG_PATHS}"

export PATH=${PG_PATHS}:${PATH}
pg_config

popd # from ${PG_SOURCE} back

# 30 seconds long
sudo useradd -r -s /bin/bash -m -d /var/lib/postgresql postgres

# When you initialize a PostgreSQL database using initdb without any extra flags, 
# the initial superuser role is automatically 
# given the same name as your operating system username, not "postgres"
# NOTE "sudo -u postgres /usr/local/pgsql/bin/initdb -D data" IS NOT ALLOWED
initdb -D data
# automatically created: cluster role "runner", database "postgres"

pg_ctl -D data -l logfile start

psql -d postgres           -c "\du"
psql -d postgres           -c "\l"

# In a PG database compiled from source the user "runner" is created.
# In a database compiled from source, the database "postgres" is created.
# The owner of the database "postgres" database is the user "runner"

# role "runner" already exists
# /usr/local/pgsql/bin/psql -d postgres           -c "CREATE ROLE runner WITH LOGIN SUPERUSER;"
psql -d postgres           -c "CREATE DATABASE runner OWNER runner;"

psql -c "SELECT version();"
psql -c "SELECT current_setting('server_version_num') "server_version_num";"

psql -c "CREATE ROLE postgres WITH LOGIN SUPERUSER;"

# OPTIONAL 
# (Just ONLY the USER-DATABASE pair mappings must exist for automatic unconstrained logging-in.)
psql -c "ALTER DATABASE postgres OWNER TO postgres;"
# psql -d postgres -c "REASSIGN OWNED BY runner TO postgres;"
# ERROR:  cannot reassign ownership of objects owned by role runner because they are required by the database system
# HOWEVER this REASSIGN works in Cygwin

psql -c "CREATE ROLE root WITH LOGIN SUPERUSER;"
psql -c "CREATE DATABASE root OWNER root;"

if [ -f "discard.txt" ]; then rm discard.txt; fi
