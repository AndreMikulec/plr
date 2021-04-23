
cd "$(dirname "$0")"

. ./init.sh

# set -v -x -e
set -e

# which R
# /c/RINSTALL/bin/x64/R

winpty -Xallow-non-tty initdb --username=${PGUSER} --pgdata="${PGDATA}" --auth=trust --encoding=utf8 --locale=C
# Success. You can now start the database server using:
# C:/msys64/mingw64/bin/pg_ctl -D C:/msys64//home/appveyor/mingw64/postgresql/Data -l logfile start
# C:/msys64/mingw64/bin/pg_ctl -D ${PGDATA} -l logfile start

# first
pg_ctl -D ${PGDATA} -l logfile start
pg_ctl -D ${PGDATA} -l logfile stop

# do again
pg_ctl -D ${PGDATA} -l logfile start
pg_ctl -D ${PGDATA} -l logfile stop

# leave it up
pg_ctl -D ${PGDATA} -l logfile start

winpty -Xallow-non-tty psql -c 'SELECT version();'

if [ "${Configuration}" = "Debug" ]
then
  echo ""                          >> Makefile
  echo "override CFLAGS += -g -O0" >> Makefile
  echo ""                          >> Makefile
fi

USE_PGXS=1 make

USE_PGXS=1 make install

winpty -Xallow-non-tty psql -c 'CREATE EXTENSION plr;'
winpty -Xallow-non-tty psql -c 'SELECT plr_version();'
winpty -Xallow-non-tty psql -c 'SELECT   r_version();'
winpty -Xallow-non-tty psql -c 'DROP EXTENSION plr;'

# must stop, else Appveyor job will hang.
pg_ctl -D ${PGDATA} -l logfile stop


# set +v +x +e
set +e
