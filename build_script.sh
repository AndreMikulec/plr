
cd "$(dirname "$0")"

. ./init.sh

logok "BEGIN build_script.sh"

# set -v -x -e
set -e

# which R msys2 and cygwin
# /c/RINSTALL/bin/x64/R
# /usr/bin/R
loginfo "which R $(which R)"

# just needed for the "make"
#
# so perl can use better regular expressions
export PATH=$(echo $(cygpath "c:\\${betterperl}\perl\bin")):${PATH}
#
# also, so I need "pexports", that is needed when,
# I try to use "postresql source code from git" to build postgres
# ("pexports" is not needed when I use the "downloadable postgrsql" source code)
export PATH=${PATH}:$(echo $(cygpath "c:\\${betterperl}\c\bin"))


if [ ! "${pg}" == "none" ]
then
  loginfo "BEGIN PostgreSQL CONFIGURE+BUILD+INSTALL"
  loginfo "BEGIN PostgreSQL CONFIGURE"
  cd ${pgsource}
  if [ "${Configuration}" == "Release" ]
  then
    ./configure --enable-depend --disable-rpath --prefix=${pgroot}
  fi
  if [ "${Configuration}" == "Debug" ]
  then
    ./configure --enable-depend --disable-rpath --enable-debug --enable-cassert CFLAGS="-ggdb -Og -g3 -fno-omit-frame-pointer" --prefix=${pgroot}
  fi
  loginfo "END   PostgreSQL CONFIGURE"
  loginfo "BEGIN PostgreSQL BUILD"
  make
  loginfo "END   PostgreSQL BUILD"
  loginfo "BEGIN PostgreSQL INSTALL"
  make install
  loginfo "END   PostgreSQL INSTALL"
  cd ${APPVEYOR_BUILD_FOLDER}
  loginfo "END   PostgreSQL BUILD + INSTALL"
  loginfo "END   PostgreSQL EXTRACT XOR CONFIGURE+BUILD+INSTALL"
fi


# put this in all non-init.sh scripts - pgroot is empty, if using an msys2 binary
# but psql is already in the path
if [ -f "${pgroot}/bin/psql" ]
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

# # loginfo "BEGIN MY ENV VARIABLES"
# export
# # loginfo "END MY ENV VARIABLES"
# 
loginfo "BEGIN verify that PLR will link to the correct PostgreSQL"
loginfo "which psql : $(which psql)"
loginfo "which pg_ctl: $(which pg_ctl)"
loginfo "which initdb: $(which initdb)"
loginfo "which postgres: $(which postgres)"
loginfo "which pg_config: $(which pg_config)"
logok   "pg_config . . ."
pg_config
loginfo "END   verify that PLR will link to the correct PostgreSQL"
# 
# ls -alrt /usr/sbin
# ls -alrt ${pgroot}/sbin
# which postgres

#
# PostgreSQL on msys2 (maybe also cygwin?) does not use(read) PG* variables [always] [correctly] (strange!)
# so, e.g. in psql, I do not rely on environment variables

# build from source
# psql: error: could not connect to server: FATAL:  role "appveyor" does not exist
# psql: error: could not connect to server: FATAL:  database "appveyor" does not exist
#

if [ "${compiler}" == "msys2" ]
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

if [ "${compiler}" == "msys2" ]
then
  winpty -Xallow-non-tty psql -d postgres -c 'SELECT version();'
else
                         psql -d postgres -c 'SELECT version();'
fi

pg_ctl -D ${PGDATA} -l logfile stop

# do again
pg_ctl -D ${PGDATA} -l logfile start


# -g3 because of the many macros
#
if [ "${Configuration}" = "Debug" ]
then
  echo ""                                                         >> Makefile
  echo "override CFLAGS += -ggdb -Og -g3 -fno-omit-frame-pointer" >> Makefile
  echo ""                                                         >> Makefile
fi

loginfo "BEGIN plr BUILDING"
USE_PGXS=1 make
loginfo "END   plr BUILDING"
loginfo "BEGIN plr INSTALLING"
USE_PGXS=1 make install
loginfo "END   plr INSTALLING"

if [ "${compiler}" == "msys2" ]
then
  winpty -Xallow-non-tty psql -d postgres -c 'CREATE EXTENSION plr;'
else
                         psql -d postgres -c 'CREATE EXTENSION plr;'
fi

if [ "${compiler}" == "msys2" ]
then
  winpty -Xallow-non-tty psql -d postgres -c 'SELECT plr_version();'
else
                         psql -d postgres -c 'SELECT plr_version();'
fi

# R 4.2.+ (on Windows utf8) sanity check
if [ "${compiler}" == "msys2" ]
then
  winpty -Xallow-non-tty psql -d postgres -c '\l template[01]'
else
                         psql -d postgres -c '\l template[01]'
fi

# How to escape single quotes within single quoted strings
# 2009 - MULTIPLE SOLUTIONS
# https://stackoverflow.com/questions/1250079/how-to-escape-single-quotes-within-single-quoted-strings

if [ "${compiler}" == "msys2" ]
then
  winpty -Xallow-non-tty psql -d postgres -c 'SELECT * FROM pg_available_extensions WHERE name = '\''plr'\'';'
else
                         psql -d postgres -c 'SELECT * FROM pg_available_extensions WHERE name = '\''plr'\'';'
fi

if [ "${compiler}" == "msys2" ]
then
  winpty -Xallow-non-tty psql -d postgres -c 'SELECT   r_version();'
else
                         psql -d postgres -c 'SELECT   r_version();'
fi

if [ "${compiler}" == "msys2" ]
then
  winpty -Xallow-non-tty psql -d postgres -c 'DROP EXTENSION plr;'
else
                         psql -d postgres -c 'DROP EXTENSION plr;'
fi

# must stop, else Appveyor job will hang.
pg_ctl -D ${PGDATA} -l logfile stop

# set +v +x +e
set +e

# ANDRE FIXED FROM - BEGIN to END
logok "END build_script.sh"

