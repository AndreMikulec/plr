
cd "$(dirname "$0")"

# mypaint/windows/msys2-build.sh
# https://github.com/mypaint/mypaint/blob/4141a6414b77dcf3e3e62961f99b91d466c6fb52/windows/msys2-build.sh
#
# ANSI control codes
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

loginfo() {
  # set +v +x
  echo -ne "${CYAN}"
  echo -n "$@"
  echo -e "${NC}"
  # set -v -x
}

logok() {
  # set +v +x
  echo -ne "${GREEN}"
  echo -n "$@"
  echo -e "${NC}"
  # set -v -x
}

logerr() {
  # set +v +x
  echo -ne "${RED}ERROR: "
  echo -n "$@"
  echo -e "${NC}"
  # set -v -x
}

logok "BEGIN init.sh"

# pwd
# /c/projects/plr

loginfo "uname -a $(uname -a)"

export R_HOME=$(cygpath "${R_HOME}")
loginfo "R_HOME ${R_HOME}"

#
# "pgsource" variable
# is only used about a custom PostgreSQL build (not a mingw or cygwin already compiled binary)
#
if [ ! "${pg}" == "repository" ]
then
  export pgsource=$(cygpath "${pgsource}")
  loginfo "pgsource ${pgsource}"
fi

export GITHUB_WORKSPACE=$(cygpath "${GITHUB_WORKSPACE}")
# echo $GITHUB_WORKSPACE
# /c/projects/plr


#
# used later to export pgversion
#
export GITHUB_ENV=$(cygpath "${GITHUB_ENV}")
# echo $GITHUB_ENV

#
# echo ${MINGW_PREFIX}
# /mingw64

if [ ! "${pg}" == "repository" ]
then
  # the place in the yaml where I told I want "pg" installed
  export pgroot=$(cygpath "${pgroot}")
fi
if [ "${pg}" == "repository" ] && [ "${compiler_style}" == "mingw" ]
then
  export pgroot=${MINGW_PREFIX}
fi
if [ "${pg}" == "repository" ] && [ "${compiler_style}" == "cygwin" ]
then
  # override (not all executables use "/usr/bin": initdb, postgres, and pg_ctl are in "/usr/sbin")
  export pgroot=/usr
fi
loginfo "pgroot $pgroot"



# proper for "initdb" - see the PostgreSQL docs
export TZ=UTC

# e.g., in the users home directory
# mingw case
if [ "${compiler_style}" == "mingw" ]
then
  export PGAPPDIR="C:/msys64$HOME"${pgroot}/postgresql/Data
fi
# cygwin case
if [ "${compiler_style}" == "cygwin" ]
then
  export PGAPPDIR=/cygdrive/c/cygwin${bit}${HOME}${pgroot}/postgresql/Data
fi
#
# add OTHER cases HERE: future arm* (guessing now)
if [ "${PGAPPDIR}" == "" ]
then
    export PGAPPDIR="$HOME"${pgroot}/postgresql/Data
fi

export     PGDATA=${PGAPPDIR}
export      PGLOG=${PGAPPDIR}/log.txt

# R.dll in the PATH
# not required in compilation
#     required in "CREATE EXTENSION plr;" and regression tests

# R in mingw does sub architectures
if [ "${compiler_style}" == "mingw" ]
then
  export PATH=${R_HOME}/bin${R_ARCH}:${PATH}
fi

if [ "${compiler_style}" == "cygwin" ]
then
  # cygwin does-not-do R sub architectures
  export PATH=${R_HOME}/bin:${PATH}
fi
loginfo "R_HOME is in the PATH $(echo ${PATH})"

logok "END   init.sh"
