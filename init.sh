


cd "$(dirname "$0")"

# pwd
# /c/projects/plr

export R_HOME=$(cygpath "${R_HOME}")

export APPVEYOR_BUILD_FOLDER=$(cygpath "${APPVEYOR_BUILD_FOLDER}")
# echo $APPVEYOR_BUILD_FOLDER
# /c/projects/plr

export plrsource=${APPVEYOR_BUILD_FOLDER}

# echo ${MINGW_PREFIX}
# /mingw64
export pginstall=${MINGW_PREFIX}

export dirpostgresql=/postgresql

# e.g., in the users home directory
export TZ=UTC
export PGAPPDIR="C:/msys64$HOME"${pginstall}/postgresql/Data
export     PGDATA=${PGAPPDIR}
export      PGLOG=${PGAPPDIR}/log.txt
export PGLOCALDIR=${pginstall}/share${dirpostgresql}/
# database params (default)
export PGDATABASE=postgres
export PGPORT=5432
export PGUSER=postgres

# not required in compilation
#     required in "CREATE EXTENSION plr;" and regression tests
export PATH=${R_HOME}/bin${R_ARCH}:$PATH
