
cd "$(dirname "$0")"

. ./init.sh

# set -v -x -e
set -e

export pg=$(postgres -V | grep -oP '(?<=\) ).*$')

pg_ctl -D ${PGDATA} -l logfile start

winpty -Xallow-non-tty psql --quiet --tuples-only -c "\pset footer off" -c "\timing off" -c "select current_setting('server_version_num')::integer;"  --output=${APPVEYOR_BUILD_FOLDER}/server_version_num.txt
# also used in compiler - msvc
./server_version_num.sh
export server_version_num=$(cat ${APPVEYOR_BUILD_FOLDER}/server_version_num.txt)

if [ ${server_version_num} -lt 100000 ]
then
  export pgversion=$(echo ${pg} | grep -oP '^\d+[.]\d+')
else
  export pgversion=$(echo ${pg} | grep -oP '^\d+')
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
