#!/bin/bash
set -x -v -e

sudo pg_lsclusters
export USE_PGXS=1
SHLIB_LINK=-lgcov PG_CPPFLAGS="-fprofile-arcs -ftest-coverage -O0" make
sudo USE_PGXS=1 make install
make installcheck PGUSER=postgres || (cat regression.diffs && false)
