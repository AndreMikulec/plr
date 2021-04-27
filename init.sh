
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
  # cygwin override
  if [ "${compiler}" == "cygwin" ]
  then
    # override (not all uses: initdb, postgres, and pg_ctl are in "/usr/sbin")
    export pgroot=/usr
  fi
fi
echo pgroot $pgroot

# e.g., in the users home directory
export TZ=UTC
export PGAPPDIR="C:/msys64$HOME"${pgroot}/postgresql/Data
# cygwin override
if [ "${compiler}" == "cygwin" ]
then
  if [ "${Platform}" == "x64" ]
  then
    export PGAPPDIR=/cygdrive/c/cygwin64${HOME}${pgroot}/postgresql/Data
  else
    export PGAPPDIR=/cygdrive/c/cygwin${HOME}${pgroot}/postgresql/Data
  fi
fi
export     PGDATA=${PGAPPDIR}
export      PGLOG=${PGAPPDIR}/log.txt

#
# not required in compilation
#     required in "CREATE EXTENSION plr;" and regression tests

if [ "${compiler}" == "msys2" ]
then
  export PATH=${R_HOME}/bin${R_ARCH}:$PATH
else # cygwin does not do R sub architectures
  export PATH=${R_HOME}/bin:$PATH
fi