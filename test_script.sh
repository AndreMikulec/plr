
cd "$(dirname "$0")"

. ./init.sh

# set -v -x -e
set -e

# put in all non-init.sh scripts - pgroot is empty, if using an msys2 binary
if [ -f "${pgroot}/bin/postgres" ]
then
  export PATH=${pgroot}/bin:${PATH}
fi

pg_ctl -D ${PGDATA} -l logfile start

USE_PGXS=1 make installcheck || (cat regression.diffs && false)

# must stop, else Appveyor job will hang.
pg_ctl -D ${PGDATA} -l logfile stop

# USE_PGXS=1 make clean
# rm -r ${PGDATA}

# set +v +x +e
set +e
