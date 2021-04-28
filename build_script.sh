
cd "$(dirname "$0")"

. ./init.sh

# set -v -x -e
set -e

# which R msys2 and cygwin
# /c/RINSTALL/bin/x64/R
# /usr/bin/R

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
    7z l "${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.zip"
    7z x "${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.zip"
    ls -alrt ${pgroot}
    cd ${APPVEYOR_BUILD_FOLDER}
    echo "END   zip EXTRACTION"
  fi
  echo "END   POSTGRESQL EXTRACT XOR CONFIGURE+BUILD+INSTALL"
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

# # later I get this information from pgconfig PKGLIBDIR SHAREDIR
# # therefore, I do not need this variable "dirpostgresql" anymore
# 
# # help determine where to extract the plr files
# # /postgresql, if the plr files are found in the
# # default cygwin-package-management shared install folders
# #
# if [ -d "${pgroot}/share/postgresql" ]
# then
#   export dirpostgresql=/postgresql
# fi

# build from source
# psql: error: could not connect to server: FATAL:  role "appveyor" does not exist
# psql: error: could not connect to server: FATAL:  database "appveyor" does not exist
#

# # echo BEGIN MY ENV VARIABLES
# export
# # echo END MY ENV VARIABLES
# 
# # echo BEGIN VERIFY THAT PLR WILL LINK TO THE CORRECT POSTGRESQL
which psql
which initdb
which postgres
which pg_config
pg_config
## echo END VERIFY THAT PLR WILL LINK TO THE CORRECT POSTGRESQL
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

#
# not yet tried/tested in cygwin
#                                                                                                                     # cygwin case
if [ "${githubcache}" == "true" ] && [ "${pggithubbincachefound}" == "false" ] && ([ -f "${pgroot}/bin/postgres" ] || [ -f "${pgroot}/sbin/postgres" ])
then
  echo BEGIN pg zip CREATION
  cd ${pgroot}
  ls -alrt  ${APPVEYOR_BUILD_FOLDER}
  7z a -r   ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.zip *
  7z l      ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.zip
  ls -alrt  ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.zip
  #
  if [ "${compiler}" == "cygwin" ]
  then
    # command will automatically pre-prepend A DIRECTORY (strange!)
    # e.g.
    pushd ${APPVEYOR_BUILD_FOLDER}
    echo appveyor PushArtifact                          pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.zip
         appveyor PushArtifact                          pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.zip
    popd
  else
    echo appveyor PushArtifact ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.zip
         appveyor PushArtifact ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.zip
  fi
  #
  cd ${APPVEYOR_BUILD_FOLDER} 
  echo END   pg zip CREATION
fi


# do again
pg_ctl -D ${PGDATA} -l logfile start


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
