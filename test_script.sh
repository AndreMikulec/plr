
set -v -x

cd "$(dirname "$0")"

. ./init.sh

USE_PGXS=1 make installcheck

# pg_ctl -D ${PGDATA} -l logfile stop
# USE_PGXS=1 make clean
# rm -r ${PGDATA}

set +v +x