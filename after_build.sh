
cd "$(dirname "$0")"

. ./init.sh

# set -v -x -e
set -e

if [ "${githubcache}" == "true" ] && [ "${pggithubbincachefound}" == "false" ] && [ -f "${pgroot}/bin/postgres" ]
then
  echo "BEGIN zip CREATION"
  cd ${pgroot}
  ls -alrt  ${APPVEYOR_BUILD_FOLDER}
  7z a -r   ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.zip *
  ls -alrt  ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.zip
  cd ${APPVEYOR_BUILD_FOLDER}
  echo "END   zip CREATION"
fi

# put in all non-init.sh scripts - pgroot is empty, if using an msys2 binary
if [ -f "${pgroot}/bin/postgres" ]
then
  export PATH=${pgroot}/bin:${PATH}
fi

pg_ctl -D ${PGDATA} -l logfile start

winpty -Xallow-non-tty psql --quiet --tuples-only -c "\pset footer off" -c "\timing off" -c "select current_setting('server_version_num')::integer;"  --output=${APPVEYOR_BUILD_FOLDER}/server_version_num.txt
# also used in compiler - msvc
./server_version_num.sh
export server_version_num=$(cat ${APPVEYOR_BUILD_FOLDER}/server_version_num.txt)
#
export pg=$(postgres -V | grep -oP '(?<=\) ).*$')
#
# override - msys2 binary case
if [ "${pg}" == "none" ]
  then
  if [ ${server_version_num} -lt 100000 ]
  then
    export pgversion=$(echo ${pg} | grep -oP '^\d+[.]\d+')
  else
    export pgversion=$(echo ${pg} | grep -oP '^\d+')
  fi
fi

pg_config | grep "^PKGLIBDIR\|^SHAREDIR" | sed "s/ = /=/" | sed s"/^/export /" > newvars.sh
. ./newvars.sh

mkdir                                 tmp
cp LICENSE                            tmp/PLR_LICENSE
mkdir -p                              tmp/lib
cp ${PKGLIBDIR}/plr.dll                  tmp/lib
mkdir -p                              tmp/share/extension
cp ${SHAREDIR}/extension/plr.control  tmp/share/extension
cp ${SHAREDIR}/extension/plr-*.sql    tmp/share/extension

export zip=plr-${gitrevshort}-pg${pgversion}-R${rversion}-${Platform}-${Configuration}-${compiler}.zip

7z a -r ${APPVEYOR_BUILD_FOLDER}/${zip} ./tmp/*

# must stop, else Appveyor job will hang.
pg_ctl -D ${PGDATA} -l logfile stop

# set +v +x +e
set +e
