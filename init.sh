
set -v -x

cd "$(dirname "$0")"

export R_HOME=$(cygpath "${R_HOME}")
export APPVEYOR_BUILD_FOLDER=$(cygpath "${APPVEYOR_BUILD_FOLDER}")
export plrsource=${APPVEYOR_BUILD_FOLDER}

export pginstall=${MINGW_PREFIX}

# e.g., in the users home directory
export TZ=UTC
export PGAPPDIR="C:/msys64/$HOME"${pginstall}/postgresql/Data
export     PGDATA=${PGAPPDIR}
export      PGLOG=${PGAPPDIR}/log.txt
export PGLOCALDIR=${pginstall}/share${dirpostgresql}/
# database params (default)
export PGDATABASE=postgres
export PGPORT=5432
export PGUSER=postgres

set +v +x
