
cd "$(dirname "$0")"

. ./init.sh

# set -v -x -e
set -e

pg_ctl -D ${PGDATA} -l logfile start

USE_PGXS=1 make installcheck || (cat regression.diffs && false)

# must stop, else Appveyor job will hang.
pg_ctl -D ${PGDATA} -l logfile stop

# USE_PGXS=1 make clean
# rm -r ${PGDATA}

# set +v +x +e
set +e
