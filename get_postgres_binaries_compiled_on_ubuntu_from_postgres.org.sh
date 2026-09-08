#!/bin/bash
set -x -v -e

if [ ! -f "${GITHUB_ENV}" ]; then touch discard.txt; export GITHUB_ENV=discard.txt; fi

# noble (24.04, LTS), plucky (25.04, amd64 only)
# https://wiki.postgresql.org/wiki/Apt
# https://apt.postgresql.org/pub/repos/apt/dists/
# ##
# https://ftp.postgresql.org/pub/repos/apt/dists/noble-pgdg/
# Regular expression search - "Package: postgresql-18$"
# https://ftp.postgresql.org/pub/repos/apt/dists/noble-pgdg/main/binary-amd64/Packages

# Inputs
# PG: Major postgres version
# PG=<major>
# Input examples
# PG=18
export PG="$1"
if [ "${PG}" == "" ]; then echo "Passed variable PG is missing."; exit 99; fi

# Outputs
# PG_HOME PG_PATHS
# PostgreSQL is installed and started

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

# Christoph Berg
# 12:01, 2 April 2026‎ Myon 
# https://wiki.postgresql.org/index.php?title=Apt&oldid=43140
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

# On Ubuntu/Debian, the PostgreSQL packaging infrastructure 
# creates the Unix account "postgres" during package installation. 
# The PostgreSQL cluster-management tooling then uses that account as the default cluster owner.
#
# 30 seconds long
# sudo useradd -r -s /bin/bash -m -d /var/lib/postgresql postgres

# on Ubuntu, installing postgresql-${PG} normally creates a default ${PG}/main cluster 
# and starts it automatically
#
# verify
pg_lsclusters

export PG_HOME="/usr/lib/postgresql/${PG}"
echo "PG_HOME=${PG_HOME}" >> ${GITHUB_ENV}
echo "PG_HOME: ${PG_HOME}"

export PG_PATHS="${PG_HOME}/bin"
echo "PG_PATHS=${PG_PATHS}" >> ${GITHUB_ENV}
echo "PG_PATHS: ${PG_PATHS}"

export PATH=${PG_PATHS}:${PATH}
pg_config

sudo apt-get install -qq postgresql-server-dev-${PG} -y

sudo --preserve-env=PATH -u postgres psql -d postgres             -c "\du"
sudo --preserve-env=PATH -u postgres psql -d postgres             -c "\l"

# In a PG database created from an Ubuntu package the user "postgres" is created.
# In a database created from an Ubuntu package, the database "postgres" is created.
# The owner of the database "postgres" database is the user "postgres".

sudo --preserve-env=PATH -u postgres psql -d postgres             -c "CREATE ROLE runner WITH LOGIN SUPERUSER;"
sudo --preserve-env=PATH -u postgres psql -d postgres             -c "CREATE DATABASE runner OWNER runner;"

psql -c "SELECT version();"
psql -c "SELECT current_setting('server_version_num') "server_version_num";"

psql -c "CREATE ROLE root WITH LOGIN SUPERUSER;"
psql -c "CREATE DATABASE root OWNER root;"

if [ -f "discard.txt" ]; then rm discard.txt; fi

