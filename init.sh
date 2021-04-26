
cd "$(dirname "$0")"

# pwd
# /c/projects/plr

export R_HOME=$(cygpath "${R_HOME}")

#
# only used about a custom PostgreSQL build (not an MSYS2 already compiled binary)
#

[ ! "${pg}" == "none" ]
then
  export pgsource=$(cygpath "c:\projects\postgresql")
fi

export APPVEYOR_BUILD_FOLDER=$(cygpath "${APPVEYOR_BUILD_FOLDER}")
# echo $APPVEYOR_BUILD_FOLDER
# /c/projects/plr


# echo ${MINGW_PREFIX}
# /mingw64

[ ! "${pg}" == "none" ]
then
  export pgroot=$(cygpath "${pgroot}")
else
  export pgroot=${MINGW_PREFIX}
fi

[ ! "${pg}" == "none" ]
then
  export dirpostgresql=/
else
  export dirpostgresql=/postgresql
fi

# e.g., in the users home directory
export TZ=UTC
export PGAPPDIR="C:/msys64$HOME"${pgroot}/postgresql/Data
export     PGDATA=${PGAPPDIR}
export      PGLOG=${PGAPPDIR}/log.txt
export PGLOCALDIR=${pgroot}/share${dirpostgresql}/
# database params (default)
export PGDATABASE=postgres
export PGPORT=5432
export PGUSER=postgres

# not required in compilation
#     required in "CREATE EXTENSION plr;" and regression tests
export PATH=${R_HOME}/bin${R_ARCH}:$PATH
