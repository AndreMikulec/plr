#!/bin/bash
set -x -v -e

pushd postgres
./configure
make
sudo make install
export PATH=/usr/local/pgsql/bin:$PATH
initdb -D data
pg_ctl -D data -l logfile start
popd
