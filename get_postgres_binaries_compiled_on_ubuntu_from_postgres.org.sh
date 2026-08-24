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
# snapshots
# sudo add-apt-repository "deb https://apt.postgresql.org/pub/repos/apt/ $(lsb_release -s -c)-pgdg-snapshot main ${PG}"
sudo add-apt-repository "deb https://apt.postgresql.org/pub/repos/apt/ $(lsb_release -s -c)-pgdg-snapshot main"

# non-snapshots
# sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# check your setup using the apt-cache policy command to see if "200" shows up in the output:
# apt-cache policy postgresql-${PG}
# apt-cache policy postgresql
apt-cache policy postgresql-${PG}

# sudo apt-get install -qq postgresql-${PG} -y
# sudo apt-get install -qq postgresql -y
sudo apt-get install -qq postgresql-${PG} -y

# sudo apt-get install -qq postgresql-server-dev-${PG} -y
# sudo apt-get install -qq postgresql-server-dev -y
sudo apt-get install -qq postgresql-server-dev-${PG} -y


echo 'local   all             postgres                                trust' | sudo tee /etc/postgresql/${PG}/main/pg_hba.conf > /dev/null
# Builds under "runner"
# Github Actions require elevated priviledges
# Ubuntu non-arm64: ubuntu-latest or ubuntu-24.04     (required)
# Ubuntu                             ubuntu-24.04-arm (not required)
# https://github.com/actions/runner-images
sudo setfacl -Rm u:postgres:rwx,d:u:runner:rwx /home/runner  || true
sudo pg_ctlcluster ${PG} main reload
