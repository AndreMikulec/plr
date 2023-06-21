
cd "$(dirname "$0")"

. ./init.sh

logok "BEGIN build_script.sh"

set -v -x -e
# set -e

export

# which R msys2 and cygwin
# /c/RINSTALL/bin/x64/R
# /usr/bin/R
loginfo "which R $(which R)"

if [ ! "${pg}" == "none" ]
then
  loginfo "BEGIN PostgreSQL EXTRACT XOR CONFIGURE+BUILD+INSTALL"
  if [ ! -f "pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z" ]
  then
    loginfo "BEGIN PostgreSQL CONFIGURE"
    cd ${pgsource}
    if [ "${Configuration}" == "Release" ]
    then
      ./configure --enable-depend --disable-rpath --without-icu --prefix=${pgroot}
    fi
    if [ "${Configuration}" == "Debug" ]
    then
      ./configure --enable-depend --disable-rpath --enable-debug --enable-cassert --without-icu CFLAGS="-ggdb -Og -g3 -fno-omit-frame-pointer" --prefix=${pgroot}
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
  else
    loginfo "BEGIN 7z EXTRACTION"
    cd ${pgroot}
    set +v +x +e
    7z l "${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z"
    set -v -x -e
    7z x "${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z"
    ls -alrt ${pgroot}
    cd ${APPVEYOR_BUILD_FOLDER}
    loginfo "END   7z EXTRACTION"
  fi
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
export
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


#
# not yet tried/tested in cygwin
#                                     # cygwin case
if [ -f "${pgroot}/bin/postgres" ] || [ -f "${pgroot}/sbin/postgres" ]
then
  loginfo "BEGIN pg 7z CREATION"
  cd ${pgroot}
  ls -alrt
  loginfo                                            "pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z"
  7z a -t7z -mmt24 -mx7 -r   ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z *
  set +v +x +e
  7z l                       ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z
  set -v -x -e
  ls -alrt                   ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z
  export  pg_7z_size=$(find "${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z" -printf "%s")
  loginfo "pg_7z_size $pg_7z_size" 
  #                       96m
  if [ ${pg_7z_size} -gt 100663296 ] 
  then
    rm -f    ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z
    loginfo "${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z is TOO BIG so removed."
  fi
  #
  if [ -f "${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z" ]
  then
    if [ "${compiler}" == "cygwin" ]
    then
      # workaround of an Appveyor-using-cygwin bug - command will automatically pre-prepend A DIRECTORY (strange!)
      # e.g.
      pushd ${APPVEYOR_BUILD_FOLDER}
      #
      # NOTE FTP Deploy will automatically PushArtifact.
      # I am ALSO pushing the artifact here, in the case the build fails, and I never reach Deploy.
      #
      # loginfo "appveyor PushArtifact                          pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z"
      #          appveyor PushArtifact                          pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z
      popd
  # bash if-then-else-fi # inside bodies can not be empty
  # else
      #
      # NOTE FTP Deploy will automatically PushArtifact.
      # I am ALSO pushing the artifact here, in the case the build fails, and I never reach Deploy.
      #
      # loginfo "appveyor PushArtifact ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z"
      #        appveyor PushArtifact ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z
    fi
  fi
  #
  cd ${APPVEYOR_BUILD_FOLDER} 
  loginfo "END   pg 7z CREATION"
fi

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

set +v +x +e
# set +e

logok "END   build_script.sh"

