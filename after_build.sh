
cd "$(dirname "$0")"

. ./init.sh

logok "BEGIN after_build.sh"

# set -v -x -e
set -e

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
cp ${SHAREDIR}/extension/plr-*.sql    tmp/share/extension

export zip=plr-${gitrevshort}-pg${pgversion}-R${rversion}-${Platform}-${Configuration}-${compiler}.zip
loginfo "${zip}"

echo ${APPVEYOR_BUILD_FOLDER}

loginfo "BEGIN plr zip CREATION"
7z a -r  ${APPVEYOR_BUILD_FOLDER}/${zip} ./tmp/*
ls -alrt ${APPVEYOR_BUILD_FOLDER}/${zip}
loginfo "BEGIN plr ZIP LISTING"
7z l     ${APPVEYOR_BUILD_FOLDER}/${zip}
loginfo "END   plr ZIP LISTING"
loginfo "END plr zip CREATION"


if [ "${compiler}" == "cygwin" ]
then
  # command will automatically pre-prepend A DIRECTORY (strange!)
  # e.g. 
  pushd ${APPVEYOR_BUILD_FOLDER}
  loginfo "appveyor PushArtifact ${zip}"
           appveyor PushArtifact ${zip}
  popd
  #
  # BAD PUSH-ARTIFACT - DEFINITELY A BUG
  #
  # loginfo "appveyor PushArtifact ${APPVEYOR_BUILD_FOLDER}/${zip}"
  #          appveyor PushArtifact ${APPVEYOR_BUILD_FOLDER}/${zip}
  #
  # appveyor PushArtifact /cygdrive/c/projects/plr/plr-761a5fbc-pg12-R4.1.0alpha-x86-Debug-cygwin.zip
  # File not found: C:\projects\plr\cygdrive\c\projects\plr\plr-761a5fbc-pg12-R4.1.0alpha-x86-Debug-cygwin.zip
  # Command exited with code 2
  # 
else
  loginfo "appveyor PushArtifact ${APPVEYOR_BUILD_FOLDER}/${zip}"
           appveyor PushArtifact ${APPVEYOR_BUILD_FOLDER}/${zip}
fi

# must stop, else Appveyor job will hang.
pg_ctl -D ${PGDATA} -l logfile stop

# set +v +x +e
set +e

logok "END   after_build.sh"
