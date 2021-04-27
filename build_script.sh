
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
#
# cygwin # pgroot: /usr - is the general location of binaries (psql) and already in the PATH
#
# $ echo $(cygpath "C:\cygwin\bin")
# /usr/bin
#
# cygwin # initdb, postgres, and pg_ctl are here "/usr/sbin"
if [ -f "${pgroot}/sbin/postgres" ]
then
  export PATH=${pgroot}/sbin:${PATH}
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

# echo BEGIN MY ENV VARIABLES
export
# echo END MY ENV VARIABLES

# echo BEGIN MY pg_config
which pg_config
pg_config
# echo END MY pg_config

ls -alrt /usr/sbin
ls -alrt ${pgroot}/sbin
which postgres



#
# PostgreSQL on msys2 does not use(read) PG* variables [correctly] (strang)
#

# build from source
# psql: error: could not connect to server: FATAL:  role "appveyor" does not exist
# psql: error: could not connect to server: FATAL:  database "appveyor" does not exist
#

if [ "compiler" == "msys2" ]
then
  winpty -Xallow-non-tty initdb --pgdata="${PGDATA}" --auth=trust --encoding=utf8 --locale=C
else
  initdb --pgdata="${PGDATA}" --auth=trust --encoding=utf8 --locale=C
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

if [ "compiler" == "msys2" ]
then
  winpty -Xallow-non-tty psql -d postgres -c 'SELECT version();'
else
  psql -d postgres -c 'SELECT version();'
fi


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

if [ "compiler" == "msys2" ]
then
  winpty -Xallow-non-tty psql -d postgres -c 'CREATE EXTENSION plr;'
else
  psql -d postgres -c 'CREATE EXTENSION plr;'
fi

if [ "compiler" == "msys2" ]
then
  winpty -Xallow-non-tty psql -d postgres -c 'SELECT plr_version();'
else
  psql -d postgres -c 'SELECT plr_version();'
fi

if [ "compiler" == "msys2" ]
then
  winpty -Xallow-non-tty psql -d postgres -c 'SELECT   r_version();'
else
  psql -d postgres -c 'SELECT   r_version();'
fi

if [ "compiler" == "msys2" ]
then
  winpty -Xallow-non-tty psql -d postgres -c 'DROP EXTENSION plr;'
else
  psql -d postgres -c 'DROP EXTENSION plr;'
fi

# must stop, else Appveyor job will hang.
pg_ctl -D ${PGDATA} -l logfile stop

# set +v +x +e
set +e
