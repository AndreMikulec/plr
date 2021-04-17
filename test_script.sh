
set -v -x

cd "$(dirname "$0")"

. ./init.sh

echo Begin USE_PGXS=1 make installcheck
USE_PGXS=1 make installcheck
echo End   USE_PGXS=1 make installcheck

# pg_ctl -D ${PGDATA} -l logfile stop
# USE_PGXS=1 make clean
# rm -r ${PGDATA}

set +v +x
