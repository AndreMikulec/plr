
cd "$(dirname "$0")"

. ./init.sh

logok "BEGIN build_script.sh"

set -v -x -e
# set -e

if [ ! "${pg}" == "repository" ]
then
  loginfo "BEGIN PostgreSQL EXTRACT XOR CONFIGURE+BUILD+INSTALL"
  if [ ! -f "pg-${os}-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z" ]
  then
    loginfo "BEGIN PostgreSQL CONFIGURE"
    cd ${PGSOURCE}
    if [ "${Configuration}" == "Release" ]
    then
      ./configure --enable-depend --disable-rpath --without-icu --prefix=${PGROOT}
    fi
    if [ "${Configuration}" == "Debug" ]
    then
      ./configure --enable-depend --disable-rpath --enable-debug --enable-cassert CFLAGS="-ggdb -Og -g3 -fno-omit-frame-pointer" --without-icu --prefix=${PGROOT}
    fi
    loginfo "END   PostgreSQL CONFIGURE"
    loginfo "BEGIN PostgreSQL BUILD"
    make
    loginfo "END   PostgreSQL BUILD"
    loginfo "BEGIN PostgreSQL INSTALL"
    make install
    loginfo "END   PostgreSQL INSTALL"
    cd ${GITHUB_WORKSPACE}
    loginfo "END   PostgreSQL BUILD + INSTALL"
  else
    loginfo "BEGIN 7z EXTRACTION"
    cd ${PGROOT}
    # 7z l "${GITHUB_WORKSPACE}/pg-${os}-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z"
    7z x "${GITHUB_WORKSPACE}/pg-${os}-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z"
    ls -alrt ${PGROOT}
    cd ${GITHUB_WORKSPACE}
    loginfo "END   7z EXTRACTION"
  fi
  loginfo "END   PostgreSQL EXTRACT XOR CONFIGURE+BUILD+INSTALL"
fi


# put this in all non-init.sh scripts - PGROOT is empty, if using a mingw binary
# but psql is already in the path
if [ -f "${PGROOT}/bin/psql" ]
then
  export PATH=${PGROOT}/bin:${PATH}
fi
#
# cygwin # PGROOT: /usr - is the general location of binaries (psql) and already in the PATH
#
# $ echo $(cygpath "C:\cygwin\bin")
# /usr/bin
#
# cygwin # initdb, postgres, and pg_ctl are here "/usr/sbin"
if [ -f "${PGROOT}/sbin/postgres" ]
then
  export PATH=${PGROOT}/sbin:${PATH}
fi

# # Later I get this information from pgconfig variables PKGLIBDIR SHAREDIR.
# # Therefore, I do not need this variable "dirpostgresql" anymore.
# 
# # helps determine where to extract the plr files . .
# #
# # Uses the "/postgresql" directory if the plr files are found in the
# # default cygwin-package-management shared install folders
# #
# if [ -d "${PGROOT}/share/postgresql" ]
# then
#   export dirpostgresql=/postgresql
# fi

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
# ls -alrt ${PGROOT}/sbin
# which postgres

#
# PostgreSQL on mingw (maybe also cygwin?) does not use(read) PG* variables [always] [correctly] (strange!)
# so, e.g. in psql, I do not rely on environment variables

if [ "${compiler_style}" == "mingw" ]
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

# build from source - try to avoid this error
# psql: error: could not connect to server: FATAL:  role "whoami" does not exist
# psql: error: could not connect to server: FATAL:  database "whoami" does not exist
#
export PGUSER=$(whoami)

if [ "${compiler_style}" == "mingw" ]
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

if [ "${compiler_style}" == "mingw" ]
then
  winpty -Xallow-non-tty psql -d postgres -c 'CREATE EXTENSION plr;'
else
                         psql -d postgres -c 'CREATE EXTENSION plr;'
fi

if [ "${compiler_style}" == "mingw" ]
then
  winpty -Xallow-non-tty psql -d postgres -c 'SELECT plr_version();'
else
                         psql -d postgres -c 'SELECT plr_version();'
fi

# R 4.2.+ (on Windows utf8) sanity check
if [ "${compiler_style}" == "mingw" ]
then
  winpty -Xallow-non-tty psql -d postgres -c '\l template[01]'
else
                         psql -d postgres -c '\l template[01]'
fi

# How to escape single quotes within single quoted strings
# 2009 - MULTIPLE SOLUTIONS
# https://stackoverflow.com/questions/1250079/how-to-escape-single-quotes-within-single-quoted-strings

if [ "${compiler_style}" == "mingw" ]
then
  winpty -Xallow-non-tty psql -d postgres -c 'SELECT * FROM pg_available_extensions WHERE name = '\''plr'\'';'
else
                         psql -d postgres -c 'SELECT * FROM pg_available_extensions WHERE name = '\''plr'\'';'
fi

if [ "${compiler_style}" == "mingw" ]
then
  winpty -Xallow-non-tty psql -d postgres -c 'SELECT   r_version();'
else
                         psql -d postgres -c 'SELECT   r_version();'
fi

if [ "${compiler_style}" == "mingw" ]
then
  winpty -Xallow-non-tty psql -d postgres -c 'DROP EXTENSION plr;'
else
                         psql -d postgres -c 'DROP EXTENSION plr;'
fi

# must stop, else Appveyor job will hang.
pg_ctl -D ${PGDATA} -l logfile stop

set +v +x +e
# set +e

logok "BEGIN build_script.sh"

