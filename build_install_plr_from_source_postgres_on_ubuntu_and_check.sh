#!/bin/bash
set -x -v -e

# sudo   USE_PGXS=1 PATH=/usr/local/pgsql/bin:$PATH SHLIB_LINK=-lgcov PG_CPPFLAGS="-fprofile-arcs -ftest-coverage -O0" make 
# sudo   USE_PGXS=1 PATH=/usr/local/pgsql/bin:$PATH make install
#        USE_PGXS=1 PATH=/usr/local/pgsql/bin:$PATH make installcheck || (cat regression.diffs && false)
       
# # sudo USE_PGXS=1 PATH=/usr/local/pgsql/bin:$PATH make clean

PATH=/usr/local/pgsql/bin:$PATH

USE_PGXS=1 SHLIB_LINK=-lgcov PG_CPPFLAGS="-fprofile-arcs -ftest-coverage -O0" make 
sudo --preserve-env=PATH USE_PGXS=1 make install
                         USE_PGXS=1 make installcheck || (cat regression.diffs && false)

# USE_PGXS=1  make clean
