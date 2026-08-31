#!/bin/bash
set -x -v -e

# sudo   USE_PGXS=1 PATH=/usr/local/pgsql/bin:$PATH SHLIB_LINK=-lgcov PG_CPPFLAGS="-fprofile-arcs -ftest-coverage -O0" make
# sudo   USE_PGXS=1 PATH=/usr/local/pgsql/bin:$PATH make install
#        USE_PGXS=1 PATH=/usr/local/pgsql/bin:$PATH make installcheck || (cat regression.diffs && false)
####
#### # # sudo USE_PGXS=1 PATH=/usr/local/pgsql/bin:$PATH make clean
####
####
#### PATH=/usr/local/pgsql/bin:$PATH
#### # could "export PATH" help ?
#### 
#### USE_PGXS=1 SHLIB_LINK=-lgcov PG_CPPFLAGS="-fprofile-arcs -ftest-coverage -O0" make
#### sudo --preserve-env=PATH USE_PGXS=1 make install
####                          USE_PGXS=1 make installcheck || (cat regression.diffs && false)
####
#### # USE_PGXS=1  make clean
####

# libR.pc THAT COMES WITH "libR R INSTALLED ON UBUNTU"
# export PKG_CONFIG_PATH=$(pwd):${PKG_CONFIG_PATH}

pg_config

# WRONG  dirname /usr/include/postgresql
# export PG_HOME=$(dirname "$(pg_config | grep "^INCLUDEDIR " | sed "s/ = /=/" | sed "s/^.*=//")")
export PG_HOME=/usr
sudo chmod 777                                                                                     "${PG_HOME}/lib/pkgconfig"
cat "${PG_HOME}/lib/pkgconfig/libpq.pc" | sed "s/libpq/libpostgres/g" | sed "s/-lpq/-lpostgres/" > "${PG_HOME}/lib/pkgconfig/libpostgres.pc"
export PATH=${PG_HOME}/lib:${PATH}
export PATH=${PG_HOME}/bin:${PATH}
export R_HOME=$(pkg-config --variable=rhome libR)
# libR.pc THAT COMES WITH "libR R INSTALLED ON UBUNTU"
# export rversion=$(Rscript --version | grep -oP "\d+[.]\d+[.]\d+")
# cat "libR.pc" | sed "s|R_HOME|${R_HOME}|" | sed "s|R_ARCH|${R_ARCH}|" | sed "s/rversion/${rversion}/" > libR.pc"

export PATH=${R_HOME}/bin:${PATH}

sudo mkdir     ${PG_HOME}/contrib
sudo chmod 777 ${PG_HOME}/contrib

sudo mkdir     ${PG_HOME}/contribplr
sudo chmod 777 ${PG_HOME}/contribplr
cp -R       *  ${PG_HOME}/contribplr

pushd     ${PG_HOME}/contribplr

  mv  meson.build __meson.build.ROOT_CONTRIB_METHOD.HIDDEN
  mv _meson.build   meson.build
  mv _meson_options.txt meson_options.txt

  meson setup --prefix="${PG_HOME}/contrib/plr" -Dbuildtype=release -Ddebug=false -Db_pie=true -DR_HOME="${R_HOME}" -DPG_HOME="${PG_HOME}" ../contrib/plr
  meson compile -C ../contrib/plr  -v

  initdb -D data
  pg_ctl -D data -l logfile start

  export PGUSER=$(whoami)
  echo "PGUSER: ${PGUSER}"

  psql -d postgres                 -c "SELECT version();"
  psql -d postgres                 -c "SELECT current_setting('server_version_num') "server_version_num";"

  export PKGLIBDIR=$(pg_config | grep "^PKGLIBDIR" | sed "s/ = /=/" | sed "s/^.*=//")

  "${PKGLIBDIR}/pgxs/src/test/regress/pg_regress" --bindir="${PG_HOME}/bin" --dbname=pl_regression plr bad_fun opt_window do out_args plr_transaction opt_window_frame parallel || (cat regression.diffs && false)

  pg_ctl -D data -l logfile stop

popd # from ${PG_HOME}/contribplr
