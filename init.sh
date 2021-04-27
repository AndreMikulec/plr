
cd "$(dirname "$0")"

# pwd
# /c/projects/plr

export R_HOME=$(cygpath "${R_HOME}")

#
# only used about a custom PostgreSQL build (not an MSYS2 already compiled binary)
#

if [ ! "${pg}" == "none" ]
then
  export pgsource=$(cygpath "c:\projects\postgresql")
fi

export APPVEYOR_BUILD_FOLDER=$(cygpath "${APPVEYOR_BUILD_FOLDER}")
# echo $APPVEYOR_BUILD_FOLDER
# /c/projects/plr


# echo ${MINGW_PREFIX}
# /mingw64

if [ ! "${pg}" == "none" ]
then
  export pgroot=$(cygpath "${pgroot}")
else
  export pgroot=${MINGW_PREFIX}
fi
echo pgroot $pgroot

# e.g., in the users home directory
export TZ=UTC
export PGAPPDIR="C:/msys64$HOME"${pgroot}/postgresql/Data
# cygwin override
if [ "compiler" == "cygwin" ]
then
  export PGAPPDIR=$(cygpath "${CYG_ROOT}")${HOME}${pgroot}/postgresql/Data
fi
export     PGDATA=${PGAPPDIR}
export      PGLOG=${PGAPPDIR}/log.txt

#
# not required in compilation
#     required in "CREATE EXTENSION plr;" and regression tests
export PATH=${R_HOME}/bin${R_ARCH}:$PATH
