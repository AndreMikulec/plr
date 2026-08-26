#!/bin/bash
set -x -v -e

# noble (24.04, LTS), plucky (25.04, amd64 only)
# https://wiki.postgresql.org/wiki/Apt
# https://apt.postgresql.org/pub/repos/apt/dists/
# ##
# https://ftp.postgresql.org/pub/repos/apt/dists/noble-pgdg/
# Regular expression search - "Package: postgresql-18$"
# https://ftp.postgresql.org/pub/repos/apt/dists/noble-pgdg/main/binary-amd64/Packages

# also start "postgres"

# Input
# export PG=<major>
export PG="$1"
# PG: Major postgres version 
# Input examples
# export PG=18

# Output
# Postgres is installed and started

# PG non-snapshots
# https://apt.postgresql.org/pub/repos/apt/dists/noble-pgdg/ (SEEN PG 19 (REL_19_) 20 (master))
#
# These "PG snapshots" are always younger than "PG non-snapshots" 
# (but the youth is sometimes only by less than 10 days)
# The CURRENT version of PG, both in the "PG non-snapshot" and the "PG snapshot"
#   is the same day and OLD. (SEEN AUG 22 2026)
# https://apt.postgresql.org/pub/repos/apt/dists/noble-pgdg-snapshot/ (SEEN PG 19 (REL_19_) 20 (master))
# Read about the snaphsots
# https://wiki.postgresql.org/wiki/Apt/FAQ#Development_snapshots
#
# if [ "${PG}" -gt "18" ]
# then
#   # snapshots (I can not find a binary package! They SHOULD BE THERE, but I can not find them.)
#   # sudo add-apt-repository "deb https://apt.postgresql.org/pub/repos/apt/ $(lsb_release -s -c)-pgdg-snapshot main ${PG}"
#   # BETTER non-snap syntax ... (I can not find a binary package! They SHOULD BE THERE, but I can not find them.)
#   # sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main-snapshot" > /etc/apt/sources.list.d/pgdg.list'
#   # wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
# else
  # non-snapshots
  # sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
  # wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
# fi

# https://wiki.postgresql.org/wiki/Apt
# non-snapshots
sudo apt-get install -qq curl ca-certificates -y
sudo install -d /usr/share/postgresql-common/pgdg
sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc
#
. /etc/os-release
sudo tee /etc/apt/sources.list.d/pgdg.sources <<EOF
Types: deb deb-src
URIs: https://apt.postgresql.org/pub/repos/apt
Suites: $VERSION_CODENAME-pgdg
Architectures: $(dpkg --print-architecture)
Components: main
Signed-By: /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc
EOF

cat /etc/apt/sources.list.d/pgdg.sources

# REQUIRED (at least by "non-snapshots")
sudo apt-get update -qq

# check your setup using the apt-cache policy command to see if "200" shows up in the output:
apt-cache policy postgresql-${PG}

sudo apt-get install -qq postgresql-${PG} -y
# automatically created: os user postgres, cluster role postgres, database postgres

sudo apt-get install -qq postgresql-server-dev-${PG} -y

## # echo 'local   all             postgres                                trust' | sudo tee /etc/postgresql/${PG}/main/pg_hba.conf > /dev/null
## # TYPE  DATABASE        USER            ADDRESS                 METHOD
## # replace contents and keep file permissions
## #    echo 'host    all             all             all                     trust' | sudo tee /etc/postgresql/${PG}/main/pg_hba.conf > /dev/null
## sudo chmod 777 /etc/postgresql/${PG}/main/pg_hba.conf
## # append contents
## sudo echo 'local   all             postgres                                trust' >>         /etc/postgresql/${PG}/main/pg_hba.conf
## sudo echo 'local   all             root                                    trust' >>         /etc/postgresql/${PG}/main/pg_hba.conf
## sudo echo 'local   all             runner                                  trust' >>         /etc/postgresql/${PG}/main/pg_hba.conf
## sudo echo 'host    all             all             all                     trust' >>         /etc/postgresql/${PG}/main/pg_hba.conf
## # access if the OS username matches the database username.
## sudo echo 'local   all             all                                     peer'  >>         /etc/postgresql/${PG}/main/pg_hba.conf
## # peer authentication is only supported on local sockets (Unix-domain sockets)
## # sudo echo 'host    all             all             all                     peer'  >>         /etc/postgresql/${PG}/main/pg_hba.conf
## sudo cat  /etc/postgresql/${PG}/main/pg_hba.conf
## # PG pg_hba.conf file change requires reload (see below)
## 
## # PostgreSQL still uses localhost as its internal default
## # sudo cat /etc/postgresql/${PG}/main/postgresql.conf | grep "listen_addresses"
## # sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/${PG}/main/postgresql.conf
## # sudo cat /etc/postgresql/${PG}/main/postgresql.conf | grep "listen_addresses"
## # PG postgresql.conf file change requires a stop then start (see below)
## 
## # Builds under "runner"
## # Ubuntu non-arm64: ubuntu-latest or ubuntu-24.04
## # Ubuntu                             ubuntu-24.04-arm
## # https://github.com/actions/runner-images
## # acl is no longer required
## # sudo apt-get install -qq acl -y
## # sudo setfacl -Rm u:postgres:rwx,d:u:runner:rwx /home/runner  || true
## 
## # only RELOAD when I know that the server is started
## sudo pg_ctlcluster ${PG} main reload
## # sudo pg_ctlcluster ${PG} main stop  # DOES NOT LIKE THIS
## # sudo pg_ctlcluster ${PG} main start # DOES NOT LIKE THIS
## 
## # ## repo (correct works AFTER pg_hba.conf configuration)
## 
## sudo -u postgres /usr/bin/psql -c "CREATE ROLE runner WITH LOGIN SUPERUSER;"
## sudo -u postgres /usr/bin/psql -c "CREATE DATABASE runner OWNER runner;"
## sudo -u postgres /usr/bin/psql -c "CREATE ROLE root WITH LOGIN SUPERUSER;"
## sudo -u postgres /usr/bin/psql -c "CREATE DATABASE root OWNER runner;"
## 
## /usr/bin/psql -c "SELECT version();"
## /usr/bin/psql -c "SELECT current_setting('server_version_num') "server_version_num";"


# maps to "/usr/bin/psql"
sudo -u postgres /usr/lib/postgresql/${PG}/bin/psql -d postgres -U postgres -c "CREATE ROLE runner WITH LOGIN SUPERUSER;"
sudo -u postgres /usr/lib/postgresql/${PG}/bin/psql -d postgres -U postgres -c "CREATE DATABASE runner OWNER runner;"

/usr/lib/postgresql/${PG}/bin/psql -c "SELECT version();"
/usr/lib/postgresql/${PG}/bin/psql -c "SELECT current_setting('server_version_num') "server_version_num";"

/usr/lib/postgresql/${PG}/bin/psql -c "CREATE ROLE root WITH LOGIN SUPERUSER;"
/usr/lib/postgresql/${PG}/bin/psql -c "CREATE DATABASE root OWNER root;"

