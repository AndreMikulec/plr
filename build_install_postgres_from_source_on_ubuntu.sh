#!/bin/bash
set -x -v -e

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

pushd postgres
# six minutes
#
# ./configure
# make
# sudo make install
#
# one minute and four seconds
#
# https://mesonbuild.com/Quick-guide.html
sudo apt-get install -qq python3 ninja-build meson -y
meson setup -Dc_link_args="-Wl,--export-dynamic" -Dbuildtype=release -Db_pie=true -Dnls=disabled -Dplperl=disabled -Dplpython=disabled -Dpltcl=disabled -Dicu=disabled -Dllvm=disabled -Dlz4=disabled -Dzstd=disabled -Dgssapi=disabled -Dldap=disabled -Dpam=disabled -Dbsd_auth=disabled -Dsystemd=disabled -Dbonjour=disabled -Dlibxml=disabled -Dlibxslt=disabled -Dreadline=enabled -Dzlib=disabled -Ddocs=disabled -Ddocs_pdf=disabled -Dcassert=false -Dtap_tests=disabled -Db_coverage=false -Ddtrace=disabled build
meson compile -C build -v
sudo meson install -C build
popd

# 30 seconds long
sudo useradd -r -s /bin/bash -m -d /var/lib/postgresql postgres

# When you initialize a PostgreSQL database using initdb without any extra flags, 
# the initial superuser role is automatically 
# given the same name as your operating system username, not "postgres"
# NOTE "sudo -u postgres /usr/local/pgsql/bin/initdb -D data" IS NOT ALLOWED
/usr/local/pgsql/bin/initdb -D data
# automatically created: cluster role "runner", database "postgres"

/usr/local/pgsql/bin/pg_ctl -D data -l logfile start

/usr/local/pgsql/bin/psql -d postgres           -c "\du"
/usr/local/pgsql/bin/psql -d postgres           -c "\l"

# In a PG database compiled from source the user "runner" is created.
# In a database compiled from source, the database "postgres" is created.
# The owner of the database "postgres" database is the user "runner"

# role "runner" already exists
# /usr/local/pgsql/bin/psql -d postgres           -c "CREATE ROLE runner WITH LOGIN SUPERUSER;"
/usr/local/pgsql/bin/psql -d postgres           -c "CREATE DATABASE runner OWNER runner;"

/usr/local/pgsql/bin/psql -c "SELECT version();"
/usr/local/pgsql/bin/psql -c "SELECT current_setting('server_version_num') "server_version_num";"

/usr/local/pgsql/bin/psql -c "CREATE ROLE postgres WITH LOGIN SUPERUSER;"
/usr/local/pgsql/bin/psql -c "ALTER DATABASE postgres OWNER TO postgres;"

# OPTIONAL 
# (Just ONLY the USER-DATABASE pair mappings must exist for automatic unconstrained logging-in.)
/usr/local/pgsql/bin/psql -c "ALTER DATABASE postgres OWNER TO postgres;"
# /usr/local/pgsql/bin/psql -d postgres -c "REASSIGN OWNED BY runner TO postgres;"
# ERROR:  cannot reassign ownership of objects owned by role runner because they are required by the database system
# HOWEVER this REASSIGN works in Cygwin

/usr/local/pgsql/bin/psql -c "CREATE ROLE root WITH LOGIN SUPERUSER;"
/usr/local/pgsql/bin/psql -c "CREATE DATABASE root OWNER root;"

## # runner@runnervmgx7h7:~/work/plr/plr$ ls -alrt data/*.conf
## # -rw------- 1 runner runner 45968 Aug 25 18:47 data/postgresql.conf
## # ...
## # -rw------- 1 runner runner  5710 Aug 25 18:47 data/pg_hba.conf
## #
## # TYPE  DATABASE        USER            ADDRESS                 METHOD
## sudo chmod 777 data/pg_hba.conf
## # append contents
## sudo echo 'local   all             postgres                                trust' >>         data/pg_hba.conf
## sudo echo 'local   all             root                                    trust' >>         data/pg_hba.conf
## sudo echo 'local   all             runner                                  trust' >>         data/pg_hba.conf
## sudo echo 'host    all             all             all                     trust' >>         data/pg_hba.conf
## # access if the OS username matches the database username.
## sudo echo 'local   all             all                                     peer'  >>         data/pg_hba.conf
## # peer authentication is only supported on local sockets (Unix-domain sockets)
## # sudo echo 'host    all             all             all                     peer'  >>         data/pg_hba.conf
## sudo cat  data/pg_hba.conf
## # PG pg_hba.conf file change requires reload (see below)
## 
## # PostgreSQL still uses localhost as its internal default
## # sudo cat data/postgresql.conf | grep "listen_addresses"
## # sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" data/postgresql.conf
## # sudo cat data/postgresql.conf | grep "listen_addresses"
## # PG postgresql.conf file change requires a stop then start (see below)
## 
## # only RELOAD (pre-requisite is that the server is started)
## sudo -u postgres /usr/local/pgsql/bin/pg_ctl -D data -l logfile reload
## 
## # REL_##_ (AFTER pg_hba.conf configuration)
## 
## # # LOGIN and SUPERUSER are cluster-level roles
## sudo -u postgres /usr/local/pgsql/bin/psql -d postgres -U postgres -c "CREATE ROLE runner WITH LOGIN SUPERUSER;"
## sudo -u postgres /usr/local/pgsql/bin/psql -d postgres -U postgres -c "CREATE DATABASE runner OWNER runner;"
## sudo -u postgres /usr/local/pgsql/bin/psql -d postgres -U postgres -c "CREATE ROLE root  WITH LOGIN SUPERUSER;"
## sudo -u postgres /usr/local/pgsql/bin/psql -d postgres -U postgres -c "CREATE DATABASE root OWNER root;"
## 
## /usr/local/pgsql/bin/psql -c  "SELECT version();"
## /usr/local/pgsql/bin/psql -c  "SELECT current_setting('server_version_num') "server_version_num";"
