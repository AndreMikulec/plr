#!/bin/bash
set -x -v -e

export PATH=/usr/local/pgsql/bin:$PATH
export USE_PGXS=1
SHLIB_LINK=-lgcov PG_CPPFLAGS="-fprofile-arcs -ftest-coverage -O0" make
sudo USE_PGXS=1 PATH=/usr/local/pgsql/bin:$PATH make install
make installcheck || (cat regression.diffs && false)
