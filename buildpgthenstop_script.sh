
cd "$(dirname "$0")"

. ./init.sh

logok "BEGIN buildpgthenstop_script.sh"

# set -v -x -e
set -e

# just needed for the "make"
#
# so perl can use better regular expressions
export PATH=$(echo $(cygpath "c:\\${betterperl}\perl\bin")):${PATH}
#
# also, so I need "pexports", that is needed when,
# I try to use "postresql source code from git" to build postgres
# ("pexports" is not needed when I use the "downloadable postgrsql" source code)
export PATH=${PATH}:$(echo $(cygpath "c:\\${betterperl}\c\bin"))


if [ "${pggithubbincacheextracted}" == "false" ] && [ ! "${pg}" == "none" ]
then
  loginfo "BEGIN PostgreSQL CONFIGURE+BUILD+INSTALL"
  if [ ! -f "pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z" ]
  then
    loginfo "BEGIN PostgreSQL CONFIGURE"
    cd ${pgsource}
    if [ "${Configuration}" == "Release" ]
    then
      ./configure --enable-depend --disable-rpath --without-icu --prefix=${pgroot}
    fi
    if [ "${Configuration}" == "Debug" ]
    then
      ./configure --enable-depend --disable-rpath --enable-debug --enable-cassert --without-icu CFLAGS="-ggdb -Og -g3 -fno-omit-frame-pointer" --prefix=${pgroot}
    fi
    loginfo "END   PostgreSQL CONFIGURE"
    loginfo "BEGIN PostgreSQL BUILD"
    make
    loginfo "END   PostgreSQL BUILD"
    loginfo "BEGIN PostgreSQL INSTALL"
    make install
    loginfo "END   PostgreSQL INSTALL"
    cd ${APPVEYOR_BUILD_FOLDER}
    loginfo "END   PostgreSQL BUILD + INSTALL"
  fi
  loginfo "END   PostgreSQL CONFIGURE+BUILD+INSTALL"
fi

#
# not yet tried/tested in cygwin
#                                                                                                                           # cygwin case
if [ "${githubcache}" == "true" ] && [ "${pggithubbincachefound}" == "false" ] && ([ -f "${pgroot}/bin/postgres" ] || [ -f "${pgroot}/sbin/postgres" ])
then
  loginfo "BEGIN pg 7z CREATION"
  cd ${pgroot}
  ls -alrt
  loginfo                                            "pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z"
  7z a -t7z -mmt24 -mx7 -r   ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z *
  7z l                       ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z
  ls -alrt                   ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z
  export  pg_7z_size=$(find "${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z" -printf "%s")
  loginfo "pg_7z_size $pg_7z_size" 
  #                       96m
  if [ ${pg_7z_size} -gt 100663296 ] 
  then
    rm -f    ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z
    loginfo "${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z is TOO BIG so removed."
  fi
  #
  if [ -f "${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z" ]
  then
    if [ "${compiler}" == "cygwin" ]
    then
      # workaround of an Appveyor-using-cygwin bug - command will automatically pre-prepend A DIRECTORY (strange!)
      # e.g.
      pushd ${APPVEYOR_BUILD_FOLDER}
      #
      # NOTE FTP Deploy will automatically PushArtifact.
      # I am ALSO pushing the artifact here, in the case the build fails, and I never reach Deploy.
      #
      # loginfo "appveyor PushArtifact                          pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z"
      #          appveyor PushArtifact                          pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z
      popd
  # bash if-then-else-fi # inside bodies can not be empty
  # else
      #
      # NOTE FTP Deploy will automatically PushArtifact.
      # I am ALSO pushing the artifact here, in the case the build fails, and I never reach Deploy.
      #
      # loginfo "appveyor PushArtifact ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z"
      #        appveyor PushArtifact ${APPVEYOR_BUILD_FOLDER}/pg-pg${pgversion}-${Platform}-${Configuration}-${compiler}.7z
    fi
  fi
  #
  cd ${APPVEYOR_BUILD_FOLDER} 
  loginfo "END   pg 7z CREATION"
fi


# set +v +x +e
set +e

logok "BEGIN buildpgthenstop_script.sh"

