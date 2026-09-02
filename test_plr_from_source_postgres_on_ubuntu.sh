#!/bin/bash
set -x -v -e

if [ "${PG_PATHS}" == "" ];  then echo "Environment variable PG_PATHS is missing.";  exit 99; fi
if [ "${R_PATHS}" == "" ];   then echo "Environment variable R_PATHS is missing.";   exit 99; fi
if [ "${R_HOME}" == "" ];    then echo "Environment variable R_HOME is missing.";    exit 99; fi
if [ "${PG_SOURCE}" == "" ]; then echo "Environment variable PG_SOURCE is missing."; exit 99; fi

# # PREVIOUSLY DONE ALREADY in "build_install_postgres_from_source_on_ubuntu.sh"
# pg_ctl -D data -l logfile start


# added to the PATH
export PATH=${R_PATHS}:${PG_PATHS}:${PATH}

#
# # pgxs (THIS WORKS!) - requires "PATH=/usr/local/pgsql/bin:$PATH"
# 
# USE_PGXS=1 SHLIB_LINK=-lgcov PG_CPPFLAGS="-fprofile-arcs -ftest-coverage -O0" make
# sudo --preserve-env=PATH USE_PGXS=1 make install
#                          USE_PGXS=1 make installcheck || (cat regression.diffs && false)
# USE_PGXS=1  make clean
# 
# # #I HAVE NOT TESTED THIS
# # sudo USE_PGXS=1 make uninstall

export PKGLIBDIR=$(pg_config | grep "^PKGLIBDIR" | sed "s/ = /=/" | sed "s/^.*=//")
echo "pg_config PKGLIBDIR: ${PKGLIBDIR}"

export BINDIR=$(pg_config | grep "^BINDIR" | sed "s/ = /=/" | sed "s/^.*=//")
echo "pg_config BINDIR: ${BINDIR}"


#
# manual regression tests
#
export PGUSER=$(whoami)
echo "PGUSER: ${PGUSER}"

psql -d postgres                 -c "SELECT version();"
psql -d postgres                 -c "SELECT current_setting('server_version_num') "server_version_num";"

pushd     "${PG_SOURCE}/contrib/cube"
"${PKGLIBDIR}/pgxs/src/test/regress/pg_regress" --bindir="${BINDIR}" --dbname=pl_regression cube cube_sci || (cat regression.diffs && false)
popd # from "${PG_SOURCE}/contrib/cube"

pushd     "${PG_SOURCE}/contrib/plr"
"${PKGLIBDIR}/pgxs/src/test/regress/pg_regress" --bindir="${BINDIR}" --dbname=pl_regression plr bad_fun opt_window do out_args plr_transaction opt_window_frame parallel || (cat regression.diffs && false)
popd # from "${PG_SOURCE}/contrib/plr"

#
# meson regression tests ( buildpgANDplrInSRCcontrib == 'true' )
#
pushd  ${PG_SOURCE}

meson test -C build --list --suite cube-running
meson test -C build -q --print-errorlogs --setup running --suite cube-running

meson test -C build --list --suite plr-running
meson test -C build -q --print-errorlogs --setup running --suite plr-running

popd # from ${PG_SOURCE} back

pg_ctl -D data -l logfile stop




