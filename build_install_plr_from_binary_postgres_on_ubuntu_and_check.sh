#!/bin/bash
set -x -v -e

# sudo pg_lsclusters
# export USE_PGXS=1
# SHLIB_LINK=-lgcov PG_CPPFLAGS="-fprofile-arcs -ftest-coverage -O0" make
# sudo USE_PGXS=1 make install
# # make installcheck PGUSER=postgres || (cat regression.diffs && false)
# make installcheck || (cat regression.diffs && false)

sudo pg_lsclusters

                 chmod 777 -R /home/runner/work/plr/plr || true
sudo -u postgres chmod 777 -R /home/runner/work/plr/plr || true
sudo             chmod 777 -R /home/runner/work/plr/plr || true

USE_PGXS=1 make clean
USE_PGXS=1 SHLIB_LINK=-lgcov PG_CPPFLAGS="-fprofile-arcs -ftest-coverage -O0" make
# "install" can not read environment variables nor pre-sudo variables
sudo USE_PGXS=1 make install
USE_PGXS=1 make installcheck || (cat regression.diffs && false)

