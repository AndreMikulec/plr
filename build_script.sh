
set -v -x

cd "$(dirname "$0")"

. ./init.sh

pwd
# /c/projects/plr

echo $APPVEYOR_BUILD_FOLDER
# /c/projects/plr

echo ${MINGW_PREFIX}
# /mingw64

# not required in compilation
#     required in "CREATE EXTENSION plr;" and regression tests
export PATH=${R_HOME}/bin${R_ARCH}:$PATH

which R
# /c/RINSTALL/bin/x64/R

winpty -Xallow-non-tty initdb --username=${PGUSER} --pgdata="${PGDATA}" --auth=trust --encoding=utf8 --locale=C
# Success. You can now start the database server using:
# C:/msys64/mingw64/bin/pg_ctl -D ${PGDATA} -l logfile start

# first
pg_ctl -D ${PGDATA} -l logfile start
pg_ctl -D ${PGDATA} -l logfile stop

# do again
pg_ctl -D ${PGDATA} -l logfile start
pg_ctl -D ${PGDATA} -l logfile stop

# leave it up
pg_ctl -D ${PGDATA} -l logfile start

psql -c 'select version();'

pg_config

USE_PGXS=1 make

USE_PGXS=1 make install

psql -c 'CREATE EXTENSION plr;'
psql -c 'DROP EXTENSION plr;'

set +v +x
