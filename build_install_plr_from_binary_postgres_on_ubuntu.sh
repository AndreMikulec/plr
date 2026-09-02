#!/bin/bash
set -x -v -e

if [ "${PG_PATHS}" == "" ]; then echo "Environment variable PG_PATHS is missing."; exit 99; fi
if [ "${R_HOME}"   == "" ]; then echo "Environment variable R_HOME is missing."  ; exit 99; fi
if [ "${R_PATHS}"  == "" ]; then echo "Environment variable R_PATHS is missing." ; exit 99; fi

# export PATH=${R_PATHS}:${PG_PATHS}:${PATH}
unset R_HOME

USE_PGXS=1 SHLIB_LINK=-lgcov PG_CPPFLAGS="-fprofile-arcs -ftest-coverage -O0" make
sudo USE_PGXS=1 make install
