#!/bin/bash
set -x -v -e

export PG_SOURCE="$1"
export PGROOT2="$2"

# save GOOD artifact plr.dll
#
if [ -f "${PG_SOURCE}/build/contrib/plr/plr.dll" ]
then
  echo "Save plr.dll to be an artifact."
  mkdir -p                                             ${GITHUB_WORKSPACE}/tmp/lib
  cp    LICENSE                                        ${GITHUB_WORKSPACE}/tmp/PLR_LICENSE
  cp    "${PG_SOURCE}/build/contrib/plr/plr.dll"       ${GITHUB_WORKSPACE}/tmp/lib
  ls -alrt                                             ${GITHUB_WORKSPACE}/tmp/lib/plr.dll
  mkdir -p                                             ${GITHUB_WORKSPACE}/tmp/share/extension
  cp    *.control                                      ${GITHUB_WORKSPACE}/tmp/share/extension
  cp    *.sql                                          ${GITHUB_WORKSPACE}/tmp/share/extension
fi

export GITHUB_WORKSPACE=$(cygpath "${GITHUB_WORKSPACE}")
#
# save GOOD artifact plr.dll.a
#
if [ -f "${PG_SOURCE}/build/contrib/plr/plr.dll.a" ]
then
  echo "Save plr.dll.a to be an artifact."
  mkdir -p                                               ${GITHUB_WORKSPACE}/tmp/lib
  cp    "${PG_SOURCE}/build/contrib/plr/plr.dll.a"       ${GITHUB_WORKSPACE}/tmp/lib
  ls -alrt                                               ${GITHUB_WORKSPACE}/tmp/lib/plr.dll.a
fi

# 7z GOOD PL/R Artifact for LATER Release
echo "7z: $(which 7z)"
echo 7z a -r ${GITHUB_WORKSPACE}/plr-artifact.zip  ${GITHUB_WORKSPACE}/tmp/*
if [ -f "${GITHUB_WORKSPACE}/tmp/PLR_LICENSE" ]
then
  echo "Create PL/R Artifact .zip for future Release"
  7z a -r ${GITHUB_WORKSPACE}/plr-artifact.zip  ${GITHUB_WORKSPACE}/tmp/*
fi

# if "PostgreSQL for Windows" exists, then
# copy "Msys artifacts into "PostgreSQL for Windows" for future testing if env.MSYS2testonpgWIN == 'true'.
#
if ( [ ! "${PGROOT2}" == "notset" ] && [ ! "${PGROOT2}" == "" ] ) && [ "${OperatingSystem}" == "Msys" ]
then
  export PGROOT2=$(cygpath "${PGROOT2}")
  echo  "cygpath PGROOT2: ${PGROOT2}"

  if [ -d "${PGROOT2}" ]
  then
    if [ -f "${PG_SOURCE}/build/contrib/plr/plr.dll" ]
    then
      echo "PGROOT2 is found. Preparing PostgreSQL for Windows testing."

      cp  "${PG_SOURCE}/build/contrib/plr/plr.dll"   "${PGROOT2}/lib"
      ls -alrt                                       "${PGROOT2}/lib/plr.dll"
      cp plr.control                                 "${PGROOT2}/share/extension"
      ls -alrt                                       "${PGROOT2}/share/extension/plr.control"
      cp plr--*.sql                                  "${PGROOT2}/share/extension"
      ls -alrt                                       "${PGROOT2}"/share/extension/plr--*.sql

    fi
  fi
fi
