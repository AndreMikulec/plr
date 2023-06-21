
cd "$(dirname "$0")"

. ./init.sh

logok "BEGIN after_test.sh"

set -v -x -e
# set -e

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

pg_ctl -D ${PGDATA} -l logfile start

if [ "${compiler}" == "msys2" ]
then
  winpty -Xallow-non-tty psql -d postgres --quiet --tuples-only -c "\pset footer off" -c "\timing off" -c "select current_setting('server_version_num')::integer;" --output=${APPVEYOR_BUILD_FOLDER}/server_version_num.txt
else
                         psql -d postgres --quiet --tuples-only -c "\pset footer off" -c "\timing off" -c "select current_setting('server_version_num')::integer;" --output=${APPVEYOR_BUILD_FOLDER}/server_version_num.txt
fi


# also used in compiler - msvc
#
./server_version_num.sh
export server_version_num=$(cat ${APPVEYOR_BUILD_FOLDER}/server_version_num.txt)
loginfo "server_version_num ${server_version_num}"
#
# also works
# export A_VAR=$(echo -n $(sed -r 's/\s+//g' a_version.txt))

loginfo "server_version_num ${server_version_num}"
loginfo "OLD pgversion ${pgversion}"
loginfo "OLD pg ${pg}"
#
# override - msys2 and cygwin binary case
if [ "${pg}" == "none" ]
  then
  export pg=$(postgres -V | grep -oP '(?<=\) ).*$')
  loginfo "NEW pg ${pg}"
  if [ ${server_version_num} -gt 999999 ]
  then
    export pgversion=$(echo ${pg} | grep -oP '^\d+')
  else
    export pgversion=$(echo ${pg} | grep -oP '^\d+[.]\d+')
  fi
  loginfo "NEW pgversion ${pgversion}"
fi
loginfo "OLD or NEW pgversion ${pgversion}"

pg_config | grep "^PKGLIBDIR\|^SHAREDIR" | sed "s/ = /=/" | sed s"/^/export /" > newvars.sh
. ./newvars.sh

mkdir                                 tmp
cp LICENSE                            tmp/PLR_LICENSE
mkdir -p                              tmp/lib
cp ${PKGLIBDIR}/plr.dll               tmp/lib
mkdir -p                              tmp/share/extension
cp ${SHAREDIR}/extension/plr.control  tmp/share/extension
cp ${SHAREDIR}/extension/plr--*.sql   tmp/share/extension

if ([ "${rversion}" == "" ] || [ "${rversion}" == "none" ])
then
  # later(now) - dynamically determing the R version
  #
  # Tomas Kalibera custom build may contain spaces 
  # so gsub replaces spaces with underscores
  # 
  
  # avoid this Warning - ignoring environment value of R_HOME
  export R_HOME_OLD=$R_HOME
  unset R_HOME
  export rversion=$(Rscript --vanilla -e 'cat(gsub('\'' '\'', replacement = '\''_'\'', x = paste0(R.version$major,'\''.'\'',R.version$minor,tolower(R.version$status))))' 2>/dev/null)
  export R_HOME=$R_HOME_OLD
fi

export var7z=plr-${gitrevshort}-pg${pgversion}-R${rversion}${rversion_more}-${Platform}-${Configuration}-${compiler}.7z
loginfo "${var7z}"

echo ${APPVEYOR_BUILD_FOLDER}

loginfo "BEGIN plr 7z CREATION"
7z a -t7z -mmt24 -mx7 -r  ${APPVEYOR_BUILD_FOLDER}/${var7z} ./tmp/*
ls -alrt                  ${APPVEYOR_BUILD_FOLDER}/${var7z}
loginfo "BEGIN plr 7z LISTING"
set +v +x +e
# 7z l                      ${APPVEYOR_BUILD_FOLDER}/${var7z}
set -v -x -e
loginfo "END   plr 7z LISTING"
loginfo "END plr 7z CREATION"


if [ "${compiler}" == "cygwin" ]
then
  # command will automatically pre-prepend A DIRECTORY (strange!)
  # e.g. 
  pushd ${APPVEYOR_BUILD_FOLDER}
  loginfo "appveyor PushArtifact ${var7z}"
           appveyor PushArtifact ${var7z}
  popd
  #
  # BAD PUSH-ARTIFACT - DEFINITELY A BUG
  #
  loginfo "appveyor PushArtifact ${APPVEYOR_BUILD_FOLDER}/${var7z}"
           appveyor PushArtifact ${APPVEYOR_BUILD_FOLDER}/${var7z}
  #
  # appveyor PushArtifact /cygdrive/c/projects/plr/plr-761a5fbc-pg12-R4.1.0alpha-x86-Debug-cygwin.7z
  # File not found: C:\projects\plr\cygdrive\c\projects\plr\plr-761a5fbc-pg12-R4.1.0alpha-x86-Debug-cygwin.7z
  # Command exited with code 2
  # 
else
  loginfo "appveyor PushArtifact ${APPVEYOR_BUILD_FOLDER}/${var7z}"
           appveyor PushArtifact ${APPVEYOR_BUILD_FOLDER}/${var7z}
fi

# must stop, else Appveyor job will hang.
pg_ctl -D ${PGDATA} -l logfile stop

#
# not yet tried/tested in cygwin
#                                                                      # cygwin case
if [ -f "${pgroot}/bin/postgres" ] && [ ! "${pgorig}" == "none" ] || [ -f "${pgroot}/sbin/postgres" ] && [ ! "${pgorig}" == "none" ]
then
  loginfo "BEGIN pg 7z CREATION"
  cd ${pgroot}
  ls -alrt
  loginfo                                            "pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z"
  7z a -t7z -mmt24 -mx7 -r   ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z *
  set +v +x +e
  # 7z l                       ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z
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
      #          appveyor PushArtifact ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z
    fi
  fi
  #
  cd ${APPVEYOR_BUILD_FOLDER} 
  loginfo "END   pg 7z CREATION"
fi

set +v +x +e
# set +e

logok "END   after_test.sh"
