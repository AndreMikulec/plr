
cd "$(dirname "$0")"

. ./init.sh

# set -v -x -e
set -e

# which R
# /c/RINSTALL/bin/x64/R

# just needed for the "make"
#
# so perl can use better regular expressions
export PATH=$(echo $(cygpath "c:\\${betterperl}\perl\bin")):${PATH}
#
# also, so I need "pexports", that is needed when,
# I try to use "postresql source code from git" to build postgres
# ("pexports" is not needed when I use the "downloadable postgrsql" source code)
export PATH=${PATH}:$(echo $(cygpath "c:\\${betterperl}\c\bin"))


if [ "${pggithubbincacheextracted}" == "false" ] && [ ! "${pg}" == "none" ]
then
  echo "BEGIN POSTGRESQL EXTRACT XOR CONFIGURE+BUILD+INSTALL"
  if [ ! -f "pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.zip" ]
  then
    echo "BEGIN POSTGRESQL CONFIGURE"
    cd ${pgsource}
    if [ "${Configuration}" == "Release" ]
    then
      ./configure --enable-depend --disable-rpath --prefix=${pgroot}
    fi
    if [ "${Configuration}" == "Debug" ]
    then
      ./configure --enable-depend --disable-rpath --enable-debug --enable-cassert --prefix=${pgroot}
    fi
    echo "END   POSTGRESQL CONFIGURE"
    echo "BEGIN POSTGRESQL BUILD"
    make
    echo "END   POSTGRESQL BUILD"
    echo "BEGIN POSTGRESQL INSTALL"
    make install
    echo "END   POSTGRESQL INSTALL"
    cd ${APPVEYOR_BUILD_FOLDER}
    echo "END   POSTGRESQL BUILD + INSTALL"
  else
    echo "BEGIN zip EXTRACTION"
    cd ${pgroot}
    7z x "${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.zip"
    ls -alrt ${pgroot}
    cd ${APPVEYOR_BUILD_FOLDER}
    echo "END   zip EXTRACTION"
  fi
  echo "END   POSTGRESQL EXTRACT XOR CONFIGURE+BUILD+INSTALL"
fi

# put this in all non-init.sh scripts - pgroot is empty, if using an msys2 binary
if [ -f "${pgroot}/bin/postgres" ]
then
  export PATH=${pgroot}/bin:${PATH}
fi

# help determine where to extract the plr files
if [ -d "${pgroot}/share/postgresql" ]
then
  export dirpostgresql=/postgresql
fi

# build from source
# psql: error: could not connect to server: FATAL:  role "appveyor" does not exist
# psql: error: could not connect to server: FATAL:  database "appveyor" does not exist
#

echo BEGIN MY ENV VARIABLES
export
echo END MY ENV VARIABLES

echo BEGIN MY pg_config
which pg_config
pg_config
echo END MY pg_config

# build from source
# psql: error: could not connect to server: FATAL:  role "appveyor" does not exist
# psql: error: could not connect to server: FATAL:  database "appveyor" does not exist
#
# minimum (strange that this env variable PGDATABASE is explictly required)
#
# not an msys2 binary
if [ ! "${dirpostgresql}" == "/postgresql" ]
then
  export PGDATABASE=appveyor
  winpty -Xallow-non-tty initdb --username=appveyor --pgdata="${PGDATA}" --auth=trust --encoding=utf8 --locale=C
else
  export PGDATABASE=postgres
  winpty -Xallow-non-tty initdb --username=postgres --pgdata="${PGDATA}" --auth=trust --encoding=utf8 --locale=C
fi

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

# build from source
# psql: error: could not connect to server: FATAL:  role "appveyor" does not exist
# psql: error: could not connect to server: FATAL:  database "appveyor" does not exist
#
winpty -Xallow-non-tty psql -c 'SELECT version();'

# -O0 because of the many macros
#
if [ "${Configuration}" = "Debug" ]
then
  echo ""                             >> Makefile
  echo "override CFLAGS += -ggdb -O0" >> Makefile
  echo ""                             >> Makefile
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
