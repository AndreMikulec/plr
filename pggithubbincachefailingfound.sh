
set -v -x

cd "$(dirname "$0")"

curl -o THROWAWAYFILE --head --fail -L ${pggithubbincacheurl}
if [ $? -eq 0 ]
then
  echo false > $(cygpath ${APPVEYOR_BUILD_FOLDER})/pggithubbincachefailingfound.sh
else
  echo true  > $(cygpath ${APPVEYOR_BUILD_FOLDER})/pggithubbincachefailingfound.sh
fi

set +v +x
