
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


if [ "${pggithubbincacheextracted}" == "false" ] && [ ! "${pg}" == "none" ]
then
  loginfo "BEGIN PostgreSQL EXTRACT XOR CONFIGURE+BUILD+INSTALL"
  if [ ! -f "pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.zip" ]
  then
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
  else
    loginfo "BEGIN zip EXTRACTION"
    cd ${pgroot}
    7z l "${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.zip"
    7z x "${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.zip"
    ls -alrt ${pgroot}
    cd ${APPVEYOR_BUILD_FOLDER}
    loginfo "END   zip EXTRACTION"
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

# # Later I get this information from pgconfig variables PKGLIBDIR SHAREDIR.
# # Therefore, I do not need this variable "dirpostgresql" anymore.
# 
# # helps determine where to extract the plr files . .
# #
# # Uses the "/postgresql" directory if the plr files are found in the
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




#
# not yet tried/tested in cygwin
#                                                                                                                           # cygwin case
if [ "${githubcache}" == "true" ] && [ "${pggithubbincachefound}" == "false" ] && ([ -f "${pgroot}/bin/postgres" ] || [ -f "${pgroot}/sbin/postgres" ])
then
  loginfo "BEGIN pg zip CREATION"
  cd ${pgroot}
  ls -alrt
  loginfo                           "pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.zip"
  7z a -r   ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.zip *
  7z l      ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.zip
  ls -alrt  ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.zip
  export   pg_zip_size=$(find "${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.zip" -printf "%s")
  loginfo "pg_zip_size $pg_zip_size" 
  #                       96m
  if [ ${pg_zip_size} -gt 100663296 ] 
  then
    rm -f    ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.zip
    loginfo "${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.zip is TOO BIG so removed."
  fi
  #
  if [ -f "${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.zip" ]
  then
    if [ "${compiler}" == "cygwin" ]
    then
      # workaround of an Appveyor-using-cygwin bug - command will automatically pre-prepend A DIRECTORY (strange!)
      # e.g.
      pushd ${APPVEYOR_BUILD_FOLDER}
      #
      # NOTE FTP Deploy will automatically PushArtifact, so I will not do that HERE.
      #
      # loginfo "appveyor PushArtifact                          pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.zip"
      #          appveyor PushArtifact                          pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.zip
      popd
  # bash if-then-else-fi # inside bodies can not be empty
  # else
      #
      # NOTE FTP Deploy will automatically PushArtifact, so I will not do that HERE.
      #
      # loginfo "appveyor PushArtifact ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.zip"
      #          appveyor PushArtifact ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.zip
    fi
  fi
  #
  cd ${APPVEYOR_BUILD_FOLDER} 
  loginfo "END   pg zip CREATION"
fi



#
# this is a "bug (or resource limitation) workaround"
#
#
# split big msys2, cygwin: pg Debug (sometimes 7z a is large and making a 1GB file from 3.5GB)
#                                              7z a -v96m - (seems) always compresses) 
#                                                          into a .azip.001 file
# after, one may manually recreate the ONE .azip file (and it is just a .zip file)
#   
# one can re-construct (and ask to override if necessary) file.azip
#   7z x file.azip.001 -tsplit
# note, the original .azip.00# files remain behind 
#
# next, rename .azip to .zip 
#       manually re-upload the .zip file to 0.0.0.0.0.GITHUBCACHE
#
# Note, not-1-GB-size files, deploy successfully to sourceforge (and that is good)
# Works well with "-v48m". 
# Below is "-v96m" and I am optimistic, that "-v96m" is hopefully still good.
#
# Note, for some strange reason, if only ONE .azip file (.azip.001) is created
# then the result MAY become SUPER_COMPRESSED 70x (to 44M).  This is WEIRD.
# I CAN NOT reapeat this locally.
#
# not yet tried/tested in cygwin
#                                                                                                                           # cygwin case
if [ "${githubcache}" == "true" ] && [ "${pggithubbincachefound}" == "false" ] && ([ -f "${pgroot}/bin/postgres" ] || [ -f "${pgroot}/sbin/postgres" ])
then
  loginfo "BEGIN pg azip CREATION"
  cd ${pgroot}
  7z a -v96m -r ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.azip *
  ls -alrt      ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.azip
  7z l          ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.azip.001
  # This does not work. I get a strange symbol in the .actn file. I do not know why.
                          ls -l ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.azip.* | wc -l  > ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.acnt
  export num_azip_files=$(ls -l ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.azip.* | wc -l)
  loginfo "num_azip_files ${num_azip_files}"
  echo cat      ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.acnt
  cat           ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.acnt
  loginfo "BEGIN list of azip splits"
  ls -alrt      ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.azip.*
  loginfo "END   list of azip splits"
  # if just one azip file, then it is just a regular zip file - BUT may be SUPER_COMPRESSED
  #   and then just rename it to a .zip file
  if [ ${num_azip_files} -eq 1 ]
  then 
    mv ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.azip.001 ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.zip
  fi
  #
  # NOTE FTP Deploy will automatically PushArtifact, so I will not do that HERE.
  #
  cd ${APPVEYOR_BUILD_FOLDER}
  loginfo "END   pg azip CREATION"
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

logok "BEGIN build_script.sh"

