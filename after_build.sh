
cd "$(dirname "$0")"

. ./init.sh

# set -v -x -e
set -e

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
  winpty -Xallow-non-tty psql -d postgres --quiet --tuples-only -c "\pset footer off" -c "\timing off" -c "select current_setting('server_version_num')::integer;"  --output=${APPVEYOR_BUILD_FOLDER}/$server_version_num.txt
else
  psql -d postgres --quiet --tuples-only -c "\pset footer off" -c "\timing off" -c "select current_setting('server_version_num')::integer;"  --output=${APPVEYOR_BUILD_FOLDER}/server_version_num.txt
fi


# also used in compiler - msvc
#
./server_version_num.sh
export server_version_num=$(cat ${APPVEYOR_BUILD_FOLDER}/server_version_num.txt)
#
# also works
# export A_VAR=$(echo -n $(sed -r 's/\s+//g' a_version.txt))

echo server_version_num ${server_version_num}

echo pg ${pg}
#
# override - msys2 and cygwin binary case
if [ "${pg}" == "none" ]
  then
  export pg=$(postgres -V | grep -oP '(?<=\) ).*$')
  echo pg ${pg}
  if [ ${server_version_num} -lt 100000 ]
  then
    export pgversion=$(echo ${pg} | grep -oP '^\d+[.]\d+')
  else
    export pgversion=$(echo ${pg} | grep -oP '^\d+')
  fi
  echo pgversion ${pgversion}
fi
echo pgversion ${pgversion}

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
echo ${zip}

echo ${APPVEYOR_BUILD_FOLDER}

echo BEGIN plr zip CREATION
7z a -r  ${APPVEYOR_BUILD_FOLDER}/${zip} ./tmp/*
ls -alrt ${APPVEYOR_BUILD_FOLDER}/${zip}
echo BEGIN plr ZIP LISTING
7z l     ${APPVEYOR_BUILD_FOLDER}/${zip}
echo END   plr ZIP LISTING
echo END plr zip CREATION


if [ "${compiler}" == "cygwin" ]
then
  # command will automatically pre-prepend A DIRECTORY (strange!)
  # e.g. 
  pushd ${APPVEYOR_BUILD_FOLDER}
  echo appveyor PushArtifact ${zip}
       appveyor PushArtifact ${zip}
  popd
  #
  # BAD PUSH-ARTIFACT - DEFINITELY A BUG
  #
  # echo appveyor PushArtifact ${APPVEYOR_BUILD_FOLDER}/${zip}
  #      appveyor PushArtifact ${APPVEYOR_BUILD_FOLDER}/${zip}
  #
  # appveyor PushArtifact /cygdrive/c/projects/plr/plr-761a5fbc-pg12-R4.1.0alpha-x86-Debug-cygwin.zip
  # File not found: C:\projects\plr\cygdrive\c\projects\plr\plr-761a5fbc-pg12-R4.1.0alpha-x86-Debug-cygwin.zip
  # Command exited with code 2
  # 
else
  echo appveyor PushArtifact ${APPVEYOR_BUILD_FOLDER}/${zip}
       appveyor PushArtifact ${APPVEYOR_BUILD_FOLDER}/${zip}
fi

# must stop, else Appveyor job will hang.
pg_ctl -D ${PGDATA} -l logfile stop

# set +v +x +e
set +e
