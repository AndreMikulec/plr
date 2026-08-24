#!/bin/bash
set -x -v -e

# sudo USE_PGXS=1 PATH=/usr/local/pgsql/bin:$PATH make clean
sudo   USE_PGXS=1 PATH=/usr/local/pgsql/bin:$PATH SHLIB_LINK=-lgcov PG_CPPFLAGS="-fprofile-arcs -ftest-coverage -O0" make 
sudo   USE_PGXS=1 PATH=/usr/local/pgsql/bin:$PATH make install
       USE_PGXS=1 PATH=/usr/local/pgsql/bin:$PATH make installcheck || (cat regression.diffs && false)
