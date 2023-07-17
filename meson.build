

# PLR is built as a "contrib" of postgres

# docs
#
# https://wiki.postgresql.org/wiki/Meson
# https://www.postgresql.org/docs/16/install-meson.html
# https://mesonbuild.com/index.html
# all the meson.build files in https://github.com/postgres/postgres/tree/REL_16_BETA2
#
# 89,000 github files
# https://github.com/search?q=path%3A**%2Fmeson.build&type=code

# Running Cygwin in imdisk RAMDISK J (2G on a 32GB memory machine) using  J_DRIVE_imdisk_2048M
# Dell machine is an XPS 8910 acquired in December 2015 and it has 4 CPU cores
# NOTE: Cygwin takes up 1.24 GB 
# If I want to do BOTH Cygwin and MINGW use J_DRIVE_imdisk_8192M

# Cygwin - everthing must be running on the SAME drive (e.g. J RAMDISK)
# (including especially minnty.exe,
# otherwise if PLR(R disk io will fail - and fail to load the package "stats")

# cygwin setup

# because of the TIME involved CONSIDER saving and extracting
# choose MAX compression
# C:\Users\AnonymousUser\Downloads\J_cygwin64_postgres-REL_16_BETA2_plr.7z
#
# rem "Command Prompt" -> Right Click -> Run As Administrator
#
# mkdir "J:\cygwin64.Downloads"
# J:
# cd "J:\cygwin64.Downloads"
#
# # Download the file "setup-x86_64.exe" from https://www.cygwin.com/install.html
# # Place the file into  "J:\cygwin64.Downloads"
# # Rename the file to setup-x86_64_3.4.7.exe (from https://www.cygwin.com/cgit/newlib-cygwin/ and SEE the greatest "Tag")
# #   using format YYYYMMDD.exe and YYYYMMMDD is the download date in years(YYYY), months(MM), and days(DD)
#
# # tight because windows keep the space
# set CYG_ARCH=x64&&set CYG_ROOT=J:\cygwin64&&set CYG_CACHE=J:\cygwin64\var\cache\setup && set CYG_MIRROR=https://mirrors.kernel.org/sourceware/cygwin/
#
# # Choose to install Cygwin into     "J:\cygwin64".
# # Choose to use the Cygwin cache at "J:\cygwin64.Downloads".

# BEGIN (SEE ONE LINE ONESHOT BELOW)
#
# setup-x86_64_3.4.7.exe -qnNdO -v -R "%CYG_ROOT%" -s "%CYG_MIRROR%" -l "%CYG_CACHE%"

# rem IMPORTANT
# setup-x86_64_3.4.7.exe -qnNdO -R "%CYG_ROOT%" -s "%CYG_MIRROR%" -l "%CYG_CACHE%" -P pkg-config -P meson -P gendef
#
# setup-x86_64_3.4.7.exe -qnNdO -R "%CYG_ROOT%" -s "%CYG_MIRROR%" -l "%CYG_CACHE%" -P cygrunsrv
#
# setup-x86_64_3.4.7.exe -qnNdO -R "%CYG_ROOT%" -s "%CYG_MIRROR%" -l "%CYG_CACHE%" -P gcc-core -P make -P tar -P gzip -P libreadline7 -P zlib -P icu-devel -P bison -P perl
# setup-x86_64_3.4.7.exe -qnNdO -R "%CYG_ROOT%" -s "%CYG_MIRROR%" -l "%CYG_CACHE%" -P flex -P libreadline-devel -P libssl-devel -P libxml2-devel -P libxslt-devel -P openldap-devel -P zlib-devel
# setup-x86_64_3.4.7.exe -qnNdO -R "%CYG_ROOT%" -s "%CYG_MIRROR%" -l "%CYG_CACHE%" -P libintl-devel -P libcrypt-devel
# setup-x86_64_3.4.7.exe -qnNdO -R "%CYG_ROOT%" -s "%CYG_MIRROR%" -l "%CYG_CACHE%" -P p7zip

# Postgres Binding Option
# REM setup-x86_64_3.4.7.exe -qnNdO -R "%CYG_ROOT%" -s "%CYG_MIRROR%" -l "%CYG_CACHE%" -P postgresql-client -P postgresql -P postgresql-devel

# setup-x86_64_3.4.7.exe -qnNdO -R "%CYG_ROOT%" -s "%CYG_MIRROR%" -l "%CYG_CACHE%" -P libpq-devel
# setup-x86_64_3.4.7.exe -qnNdO -R "%CYG_ROOT%" -s "%CYG_MIRROR%" -l "%CYG_CACHE%" -P R -P R-debuginfo
#
# END

# XOR
# BEGIN - WITHOUT - Postgres Binding Option
# setup-x86_64_3.4.7.exe -qnNdO -R "%CYG_ROOT%" -s "%CYG_MIRROR%" -l "%CYG_CACHE%" -P pkg-config -P meson -P gendef -P cygrunsrv  -P gcc-core -P make -P tar -P gzip -P libreadline7 -P zlib -P icu-devel -P bison -P perl -P flex -P libreadline-devel -P libssl-devel -P libxml2-devel -P libxslt-devel -P openldap-devel -P zlib-devel -P libintl-devel -P libcrypt-devel -P libintl-devel -P libcrypt-devel -P p7zip -P libpq-devel -P R -P R-debuginfo
# END
#
# NOTE: may want to 7z UP that file NOW OR LATER (after I expand out REL_16_BETA_2 and place into contrib andremikulec_plr)
# J_cygwin64_and_PLR_R_Postgres_REL_16_BETA_2_contrib.7z
#
# set SHELL=%CYG_ROOT%\bin\bash.exe
# shutdown current
# %SHELL% -login -c "cygrunsrv -E cygserver || true"
# uninstall previous
# %SHELL% -login -c "cygrunsrv -R cygserver || true"
# install
# %SHELL% -login -c "cygserver-config --yes"
# copy %CYG_ROOT%\etc\defaults\etc\cygserver.conf %CYG_ROOT%\etc\defaults\etc\cygserver.conf.original
# echo kern.ipc.shmmni 32767 >> %CYG_ROOT%\etc\defaults\etc\cygserver.conf
# echo kern.ipc.shmseg 32767 >> %CYG_ROOT%\etc\defaults\etc\cygserver.conf
# start
# %SHELL% -login -c "cygrunsrv -S cygserver"

# Start the Cygwin command prompt METHOD 1
#
# %SHELL% -login -c "PATH="""" CHERE_INVOKING=1 ""J:\cygwin64\bin\mintty.exe"" -~ -T J:\cygwin64 -o FontHeight=14 -o Font=""Lucida Console"" -p center -s 160,20 -i /Cygwin-Terminal.ico -"
# export PATH=/usr/local/bin:/usr/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:.:/usr/lib/lapack
#
# Start the Cygwin command prompt METHOD 2 (BETTER)
#
# set PATH=
# set CHERE_INVOKING=1
# "J:\cygwin64\bin\mintty.exe" -~ -T J:\cygwin64 -o FontHeight=14 -o Font="Lucida Console" -p center -s 160,20 -i /Cygwin-Terminal.ico -

# Start the Cygwin command prompt METHOD 3 (from a current mintty)
#
# $(cygpath "J:\cygwin64\bin\mintty.exe") -~ -T J:\cygwin64 -o FontHeight=14 -o Font="Lucida Console" -p center -s 160,20 -i /Cygwin-Terminal.ico &

# In minnty do
# mkdir       /cygdrive/j/tmp
# export  TMP=/cygdrive/j/tmp
# export TEMP=/cygdrive/j/tmp
#
# XOR RUN
# J:\cygwin64.Downloads>>W:\APPLICATIONS_DESKTOP\cygwin64_on_J.vbs
#
# VERIFY THE PATH
# $ echo ${PATH}
# /usr/local/bin:/usr/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:.:/usr/lib/lapack


# modify the libR.pc pkg-config file
# ----------------------------------

# mingw
# We default to pkgconf as our pkg-config implementation
# https://www.msys2.org/docs/pkgconfig/
#
# PKG_CONFIG_SYSTEM_INCLUDE_PATH
# https://man.archlinux.org/man/pkgconf.1.en

# AnonymousUser@ANONYMOUST UCRT64 /j/postgres-REL_16_BETA2
# # export | grep PKG_CONFIG
# declare -x PKG_CONFIG_PATH="/ucrt64/lib/pkgconfig:/ucrt64/share/pkgconfig"
# declare -x PKG_CONFIG_SYSTEM_INCLUDE_PATH="/ucrt64/include"
# declare -x PKG_CONFIG_SYSTEM_LIBRARY_PATH="/ucrt64/lib"

# meson does not read environment variable, but maybe meson will read these
# NO - DID NOT WORK
# export PKG_CONFIG_SYSTEM_INCLUDE_PATH="/c/Program Files/R/R-4.2.3/include":${PKG_CONFIG_SYSTEM_INCLUDE_PATH}
# export PKG_CONFIG_SYSTEM_LIBRARY_PATH="/c/Program Files/R/R-4.2.3/bin/x64":${PKG_CONFIG_SYSTEM_LIBRARY_PATH}
# 
# export PKG_CONFIG_SYSTEM_INCLUDE_PATH="/c/Program Files/R/R-4.2.3":${PKG_CONFIG_SYSTEM_INCLUDE_PATH}
# export PKG_CONFIG_SYSTEM_LIBRARY_PATH="/c/Program Files/R/R-4.2.3/bin":${PKG_CONFIG_SYSTEM_LIBRARY_PATH}

# declare -x PKG_CONFIG_PATH="/ucrt64/lib/pkgconfig:/ucrt64/share/pkgconfig"
# declare -x PKG_CONFIG_SYSTEM_INCLUDE_PATH="/ucrt64/include"
# declare -x PKG_CONFIG_SYSTEM_LIBRARY_PATH="/ucrt64/lib"

# export

# non-mingw follows

# ### SEE https://linux.die.net/man/1/pkg-config
# ### NOTICE: --msvc-syntax
#
# ### SEE Joe Conway's plr Makefile
# ### https://github.com/postgres-plr/plr/blob/3305e4fd2acf623744624f2b8f22f2e0076d94cf/Makefile
#
# AnonymousUser@ANONYMOUST /cygdrive/j/postgres-master_e9f15bc_2307081419
# $ cat /lib/pkgconfig/libR.pc
#
# rhome=/usr/lib/R
# rlibdir=${rhome}/lib
# rincludedir=/usr/lib/R/include
#
# Name: libR
# Description: R as a library
# Version: 4.3.0
# Libs: -fopenmp   -L${rlibdir} -lR
# Cflags: -I${rincludedir} -I${rincludedir}
# Libs.private:
#
# AnonymousUser@ANONYMOUST /cygdrive/j/postgres-master_e9f15bc_2307081419
# $ cp  /lib/pkgconfig/libR.pc  /lib/pkgconfig/libR.pc.original
#
# AnonymousUser@ANONYMOUST /cygdrive/j/postgres-master_e9f15bc_2307081419
# $ vi  /lib/pkgconfig/libR.pc
# XOR BETTER
# vi -c "set number" -c "set showmode" -c "set mouse-=a" /lib/pkgconfig/libR.pc
#
# rhome=/usr/lib/R
# r_libdir1x=${rhome}/bin
# r_libdir2x=${rhome}/lib
# rincludedir=/usr/lib/R/include
#
# Name: libR
# Description: R as a library
# Version: 4.3.0
# Libs: -fopenmp   -L${r_libdir1x} -L${r_libdir2x} -lR
# Cflags: -I${rincludedir} -I${rincludedir}
# Libs.private:

# R on Windows case
# notepad /ucrt64/lib/pkgconfig/libR.pc
# 
# rhome=/c/Program Files/R/R-4.2.3
# rarch=/x64
# prefix=${rhome}
# exec_prefix=${prefix}
# 
# r_libdir1x=${rhome}/bin${rarch}
# r_libdir2x=${rhome}/lib${rarch}
# rincludedir=${rhome}/include
# 
# Name: libR
# Description: R as a library
# Version: 4.2.3
# Libs: -fopenmp   -L${r_libdir1x} -L${r_libdir2x} -lR
# Cflags: -I${rincludedir} -I${rincludedir}
# Libs.private:



# UNZIP 
# expand postgres-REL_16_BETA2.zip to J:\postgres-REL_16_BETA2
#

# Of postgres REL_16_BETA2 and later . . .
# In the file contrib\meson.build
# add this line "subdir('plr')" as the top subdir.
#

# In the directory "contrib", create the subdirectory "plr".
# Place the contents of andremikulec_plr there.
# TWO new files ARE expected:
# meson.build
# meson_options.txt_postgres_root_additions

#
# Append the contents of the file contrib/plr/meson_options.txt_postgres_root_additions
# to the file J:\postgres-REL_16_BETA2\meson_options.txt
#

# From the Cygwin command prompt (July 11, 2023)
#
# Determine the installed version of R and write it ito the setup LINE below . .
# R --version
# R version 4.3.0 (2023-04-21) -- "Already Tomorrow"
#
#
# pushd "J:\postgres-REL_16_BETA2"
# rm -Rf build
# export R_HOME=/usr/lib/R && unset RTOOLS43_HOME
# export | grep R_HOME
# rem J is my RAMDISK
# rem C is permanent if I want a more permanent SOLUTION : --prefix /cygdrive/c/PGINSTALL
# note: - features - auto_features is enabled,  buildtype is "release", readline is enabled, PIE is true, -Dextra_version is _$(basename $(pwd))
# #
# meson setup --prefix /cygdrive/j/PGINSTALL -Drversion=4.3.0 -DR_HOME='/usr/lib/R' -Dbuildtype=release -Db_pie=true -Dnls=disabled -Dplperl=disabled -Dplpython=disabled -Dpltcl=disabled -Dicu=disabled -Dllvm=disabled -Dlz4=disabled -Dzstd=disabled -Dgssapi=disabled -Dldap=disabled -Dpam=disabled -Dbsd_auth=disabled -Dsystemd=disabled -Dbonjour=disabled -Dlibxml=disabled -Dlibxslt=disabled -Dreadline=enabled -Dzlib=disabled -Dextra_version=_$(basename $(pwd)) -Ddocs=disabled -Ddocs_pdf=disabled -Dcassert=false -Dtap_tests=disabled -Db_coverage=false -Ddtrace=disabled build


#  mingw AND "R for Windows"(msvc,mingw) + R and PLR (includes "readline")
# From the windows command prompt
#
# pushd "J:\postgres-REL_16_BETA2"
#
# AnonymousUser@ANONYMOUST UCRT64 /j/postgres-REL_16_BETA2
# mkdir -p    /cygdrive/j/tmp
# export  TMP=/cygdrive/j/tmp
# export TEMP=/cygdrive/j/tmp
#
# export R_HOME="/c/Program Files/R/R-4.2.3"
# unset RTOOLS43_HOME
# export | grep R_HOME
# export R_ARCH=/x64
# note - features SAME as above but DIFFERENT  -Dextra_version is _UCRT64
# AnonymousUser@ANONYMOUST UCRT64 /j/postgres-REL_16_BETA2
#
# mingw is /j (but cygwin is /cygdrive/j)
#
# meson setup --prefix /j/PGINSTALL -Drversion=4.2.3 -DR_HOME='C:\Program Files\R\R-4.2.3' -DR_ARCH='/x64' -Dbuildtype=release -Db_pie=true -Dnls=disabled -Dplperl=disabled -Dplpython=disabled -Dpltcl=disabled -Dicu=disabled -Dllvm=disabled -Dlz4=disabled -Dzstd=disabled -Dgssapi=disabled -Dldap=disabled -Dpam=disabled -Dbsd_auth=disabled -Dsystemd=disabled -Dbonjour=disabled -Dlibxml=disabled -Dlibxslt=disabled -Dreadline=enabled -Dzlib=disabled -Dextra_version=_UCRT64 -Ddocs=disabled -Ddocs_pdf=disabled -Dcassert=false -Dtap_tests=disabled -Db_coverage=false -Ddtrace=disabled build
#
# not this (because I must do a full build before an incremental build of just "plr")
#
# If these is NOT installed (and these MAY BE OLD)
# -P postgresql-client -P postgresql -P postgresql-devel
# and if this is ran
# rm -Rf build/contrib/plr/*
# meson compile -C build -v contrib/plr/plr:shared_module
# then later
# meson test -C build --num-processes 1 -v --suite setup
# ERROR: File 'src/port/libpgport.a' could not be found

#
# optionally run to change the --prefix
# meson configure --prefix /cygdrive/j/PGINSTALL

# this
#
# meson compile -C build -v
# # (Meson test has no concept of pre-required "test", so this is an EnterprisDB working hack.)
# meson test -C build --num-processes 1 -v --suite setup
# now may be faster
# meson test -C build --num-processes 1 -v --suite setup --suite plr

# after the full build
# if I forgot earlier to add the "plr" source folder, then
#
# AnonymousUser@ANONYMOUST /cygdrive/j/postgres-REL_16_BETA2
# $ meson test -C build --num-processes 1 -v --suite setup --suite plr
# ninja: no work to do.
# No suitable tests defined.
#
# $ meson compile -C build -v contrib/plr
# INFO: autodetecting backend as ninja
#
# ERROR: Can't invoke target `contrib/plr`: target not found
#
# if I forgot earlier to add the "plr" source folder, then
# .1 add it now "plr" to "contrib/plr"
# .2 add an entry "subdir('plr')" in contrib/meson.build
# .3 run below . .
# meson compile -C build -v contrib
# # meson detects plr and "re-setups" and "compiles ONLY plr"
# .3ALT
# If the response is"ninja: no work to do."
# then do these BOTH
# rm -Rf build/contrib/plr/*
# meson compile -C build -v contrib
# # no "re-setup" happens, just "plr compilaton" happens, so THIS IS FAST)
# .3SUMMARY
# most safe (combo) to do re-tests
# rm -Rf build/contrib/plr/*
# meson compile -C build -v contrib
# .4 run below
# meson test -C build --list --suite setup --suite plr
#   ninja: no work to do.
#   postgresql:setup / tmp_install
#   postgresql:setup / install_test_files
#   postgresql:plr / plr/regress

# meson test -C build --num-processes 1 -v --suite setup --suite plr
#

# running tests
#
# meson install -C build
# mkdir -p /cygdrive/j/PGDATA
# ../PGINSTALL/bin/initdb -D /cygdrive/j/PGDATA
# ../PGINSTALL/bin/pg_ctl -D /cygdrive/j/PGDATA -l logfile start
# ../PGINSTALL/bin/createdb test
# export PGUSER=$(whoami)
# if I want to browse inside (optional)
# ../PGINSTALL/bin/psql test
# meson test -C build --num-processes 1 -v --setup running --suite plr-running
# meson test -C build --list --suite setup-running --suite plr-running

# running postgres is required
#
# build/src/test/regress/pg_regress --inputdir contrib/plr plr bad_fun opt_window do out_args plr_transaction opt_window_frame
# # using postmaster on Unix socket, default port
#   ok 1         - plr                                       917 ms
#   ok 2         - bad_fun                                   506 ms
#   ok 3         - opt_window                                460 ms
#   ok 4         - do                                        440 ms
#   ok 5         - out_args                                  472 ms
#   ok 6         - plr_transaction                           501 ms
#   ok 7         - opt_window_frame                          446 ms
#   1..7
#   # All 7 tests passed.

# ../PGINSTALL/bin/pg_ctl -D /cygdrive/j/PGDATA -l logfile stop
# rm -Rf /cygdrive/j/PGDATA
# rm -Rf /cygdrive/j/PGINSTALL

# DONE
# clean up in the Administrators Prompt
#
# shutdown current
# %SHELL% -login -c "cygrunsrv -E cygserver"
# uninstall previous
# %SHELL% -login -c "cygrunsrv -R cygserver"


# Core
# -Dbuildtype=release

# CAN BE specific
# -Db_pie=true
#
# cygwin
#
# meson configure
#
#   Core options                    Default Value                     Possible Values                   Description
#   --------------                  -------------                     ---------------                   -----------
#   buildtype                      debug                              [plain, debug, debugoptimized,    Build type to use
#                                                                     release, minsize, custom]
#
#   optimization                    0                                 [plain, 0, g, 1, 2, 3, s]
#   warning_level                   1                                 [0, 1, 2, 3]                      Compiler warning level to use
#
#   Base options                    Default Value                     Possible Values                   Description
#   --------------                  -------------                     ---------------                   -----------
#   b_coverage                      false                             [true, false]                     Enable coverage tracking.
#   b_ndebug                        false                             [true, false, if-release]         Disable asserts
#   b_pch                           true                              [true, false]                     Use precompiled headers
#   b_pie                           false                             [true, false]                     Build executables as position independent
#   b_staticpic                     true                              [true, false]                     Build static libraries as position independent
#
#   Compiler options                Default Value                     Possible Values                   Description
#   ------------------              -------------                     ---------------                   -----------
#   c_args                          []                                []                                Extra arguments passed to the c compiler
#   c_link_args                     []                                []                                Extra arguments passed to the c linker
#   c_std                           none                              [none, c89, c99, c11, c17, c18,   C language standard to use
#                                                                      c2x, gnu89, gnu99, gnu11, gnu17,
#                                                                      gnu18, gnu2x]
#   build.c_args                    []                                []                                Extra arguments passed to the c compiler
#   build.c_link_args               []                                []                                Extra arguments passed to the c linker
#   build.c_std                     none                              [none, c89, c99, c11, c17, c18,   C language standard to use
#                                                                      c2x, gnu89, gnu99, gnu11, gnu17,
#                                                                      gnu18, gnu2x]
#   pkgconfig module options        Default Value                     Possible Values                   Description
#   --------------------------      -------------                     ---------------                   -----------
#   pkgconfig.relocatable           false                             [true, false]                     Generate pkgconfig files as relocatable
#
#   Testing options                 Default Value                     Possible Values                   Description
#   -----------------               -------------                     ---------------                   -----------
#   errorlogs                       true                              [true, false]                     Whether to print the logs from failing tests
#   stdsplit                        true                              [true, false]                     Split stdout and stderr in test logs

# BEGIN MSYS2
#
# Can not install msys2 on FAKE RAMDISK J.
# Msys2 does not allow that.  The disk must be Real (C:)
# 
# Can not copy msys2 installation from C to J
# When I compile on J this will happen.
# This will cause compilation to fail

# "-LC:/msys64STARTER/ucrt64/lib/x64"

# rem currenlty not used
# rem set MSYS_ARCH=x64
# 
# set    MSYS_ROOT=C:\msys64PLR
# set MSYS_CACHE=%MSYS_ROOT%.var.cache.setup
# mkdir          %MSYS_CACHE%
# mkdir          %MSYS_ROOT%.Downloads
# Place in THERE msys2-x86_64-20230526.exe

# cd %MSYS_ROOT%.Downloads
# # place the file msys2-x86_64-20230526.exe HERE
# # msys2-x86_64-20230526.exe --help (https://www.msys2.org/ - Download the Installer)
#
# msys2-x86_64-20230526.exe --help
# 
# MSYS2 Silent Install (How-To Guide)
# Written by Jason Bergnerin Software Title
# 2021 SEEN 2023
# https://silentinstallhq.com/msys2-silent-install-how-to-guide/
# https://github.com/msys2/msys2-installer
#
# rem 
# rem               %MSYS_ROOT% -  MUST NOT BE pre-existing. (The program will    create it.)
# rem --cache-path %MSYS_CACHE% -  MUST     BE pre-existing. (The program can not create it.)
# msys2-x86_64-20230526.exe --verbose --confirm-command --default-answer  --accept-licenses --no-size-checking --root %MSYS_ROOT% --cache-path %MSYS_CACHE% install
# 
# NOTES
# https://www.msys2.org/wiki/MSYS2-installation/

# C:\msys64STARTER\msys2_shell.cmd --help
# MSYS does not require Administrator Privs
# RUN 
# C:\msys64PLR\msys2_shell.cmd -ucrt64
 
# mkdir -p    /cygdrive/j/tmp
# export  TMP=/cygdrive/j/tmp
# export TEMP=/cygdrive/j/tmp
#
# export R_HOME="/c/Program Files/R/R-4.2.3"
# unset RTOOLS43_HOME
# export | grep R_HOME
# export R_ARCH=/x64

# NEEDED TO BE INSTALLED
# pacman --needed -S bash pacman pacman-mirrors msys2-runtime
# pacman -S --needed --noconfirm mingw-w64-ucrt-x86_64-pkg-config mingw-w64-ucrt-x86_64-curl git mingw-w64-ucrt-x86_64-meson mingw-w64-ucrt-x86_64-make mingw-w64-ucrt-x86_64-gcc tar gzip mingw-w64-ucrt-x86_64-readline mingw-w64-ucrt-x86_64-zlib mingw-w64-ucrt-x86_64-icu icu-devel git flex bison mingw-w64-ucrt-x86_64-perl mingw-w64-ucrt-x86_64-winpty p7zip tar zstd mingw-w64-ucrt-x86_64-tools-git mingw-w64-ucrt-x86_64-binutils mingw-w64-ucrt-x86_64-diffutils
#
# Total Download Size:   146.71 MiB
# Total Installed Size:  951.06 MiB (actually about 311 MB)
#
##  Creating library R.lib and object R.exp
#
# pushd "$R_HOME/bin$R_ARCH"
# gendef - R.dll > R.def
##  * [R.dll] Found PE+ image
# export mslib="/c/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.36.32532/bin/HostX64/x64/lib" 
# "${mslib}" "/def:R.def" "/out:R.lib" "/MACHINE:x64"
#
## Creating mingw "import lib" libR.a
#
# dlltool --dllname R.dll --def R.def --output-lib libR.a
# 

#  copy
#  C:\Program Files\R\R-4.2.3\bin\x64
#  R.dll
#  R.def
#  R.exp
#  R.lib
#  libR.a
#  to
#  C:\msys64PLR\ucrt64\lib
#  
#  rm -Rf build

#  export PATH="/c/Program Files/R/R-4.2.3/bin/x64":$PATH
#  meson setup . . .
#  meson compile . . .
#  WORKS (COMPILES)

# mingw TO COMPILE and PASS TESTS
# SUMMARY: R is in PATH
# in /ucrt64/lib [at least] one of R.dll, REDIRECTORS:  R.lib,  Rlib.dll.a (a.k.a Rlib.a) 
#

# popd

# AnonymousUser@ANONYMOUST UCRT64 /j/postgres-REL_16_BETA2
# # meson compile -C build -v contrib/plr/plr:shared_module
# INFO: autodetecting backend as ninja
# INFO: calculating backend command to run: C:\msys64PLR\ucrt64\bin/ninja.EXE -C J:/postgres-REL_16_BETA2/build -v contrib/plr/plr.dll
# ninja: Entering directory `J:/postgres-REL_16_BETA2/build'
# 
# [1/1] 
# "cc" -o contrib/plr/plr.dll
# contrib/plr/plr.dll.p/win32ver.obj
# contrib/plr/plr.dll.p/plr.c.obj
# contrib/plr/plr.dll.p/pg_conversion.c.obj
# contrib/plr/plr.dll.p /pg_backend_support.c.obj
# contrib/plr/plr.dll.p/pg_userfuncs.c.obj
# contrib/plr/plr.dll.p/pg_rsupport.c.obj
# "-Wl,--allow-shlib-undefined" "-Wl,-O1" "-shared" "-Wl,--s
# tart-group" "-Wl,--out-implib=contrib/plr/plr.dll.a"
# "-Wl,--stack,4194304" "-Wl,--allow-multiple-definition"
# "-Wl,--disable-auto-import" "-fopenmp" "-LC:/msys64PLR/u
# crt64/lib/x64" "-LC:/msys64PLR/ucrt64/bin/x64" "-lR"
# "-fvisibility=hidden"
# "J:/postgres-REL_16_BETA2/build/src/backend/libpostgres.exe.a"
# "-pthread" "C:/msys64PLR/uc rt64/lib/libssl.dll.a"
# "C:/msys64PLR/ucrt64/lib/libcrypto.dll.a" "-lws2_32" "-lm"
# "-lkernel32" "-luser32" "-lgdi32" "-lwinspool" "-lshell32"
# "-lole32" "-loleaut32" " -luuid" "-lcomdlg32" "-ladvapi32"
# "-Wl,--end-group"
# 

# pushd "J:\postgres-REL_16_BETA2"
#
# cleanup
# zip it up
# remove it
# rmdir /S /Q %MSYS_ROOT%
# or just leeve it on disk

# END MSYS2

# BEGIN MSVC
# 
# rem NOTICE in the PATH: C:\Program Files\R\R-4.2.3\bin\x64
# set PATH=C:\ProgramData\chocolatey\bin;C:\Program Files\R\R-4.2.3\bin\x64;C:\Strawberry\perl\bin;C:\ProgramData\chocolatey\bin;C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.36.32532\bin\HostX64\x64;C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\VC\VCPackages;C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\TestWindow;C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer;C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\bin\Roslyn;C:\Program Files\Microsoft Visual Studio\2022\Community\Team Tools\Performance Tools\x64;C:\Program Files\Microsoft Visual Studio\2022\Community\Team Tools\Performance Tools;C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.6.1 Tools\x64\;C:\Program Files (x86)\Windows Kits\10\bin\10.0.22621.0\\x64;C:\Program Files (x86)\Windows Kits\10\bin\\x64;C:\Program Files\Microsoft Visual Studio\2022\Community\\MSBuild\Current\Bin\amd64;C:\Windows\Microsoft.NET\Framework64\v4.0.30319;C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\;C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\;C:\ActiveTcl\bin;C:\Python310\Scripts\;C:\Python310\;C:\Users\AnonymousUser\AppData\Local\Android\Sdk\platform-tools;C:\Program Files\Amazon Corretto\jdk11.0.16_8\bin;C:\gtk+-bundle_3.6.4-20130513_win64\bin;C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v10.1\bin;C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v10.1\libnvvp;W:\Oracle19cC\bin;W:\Oracle19cB\bin;W:\Oracle19cA\bin;C:\Program Files\Git\bin;C:\Program Files (x86)\sox-14-4-2;C:\ProgramFiles\MIT\Kerberos\bin;C:\Program Files\Perforce\;C:\WINDOWS\System32\OpenSSH\;C:\Program Files\Gource\cmd;C:\Program Files\TortoiseSVN\bin;C:\Program Files\doxygen\bin;C:\WINDOWS;C:\WINDOWS\system32;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\;C:\Program Files\dotnet\;C:\Program Files\LLVM\bin;C:\ProgramData\Anaconda3;C:\Python27;C:\Users\AnonymousUser\AppData\Local\bin\NASM;W:\depot_tools;C:\Program Files (x86)\Windows Kits\10\Debuggers\x64;C:\Users\AnonymousUser\scoop\shims;C:\OTHERBIN;C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\;C:\WINDOWS\System32\OpenSSH\;C:\Program Files (x86)\AOMEI\AOMEI Backupper\6.6.1;C:\Program Files (x86)\Intel\Intel(R) Management Engine Components\DAL;C:\Program Files\Intel\Intel(R) Management Engine Components\DAL;C:\Program Files\PuTTY\;C:\OTHERBIN\rclone-v1.59.0-windows-amd64;C:\flutter\bin;C:\Users\AnonymousUser\AppData\Local\Programs\Microsoft VS Code;C:\Program Files\nodejs\;C:\ProgramData\chocolatey\bin;C:\Program Files (x86)\Calibre2\;C:\Program Files (x86)\GitExtensions\;C:\Program Files\MiKTeX\miktex\bin\x64\;C:\Program Files (x86)\Windows Kits\10\Windows Performance Toolkit\;C:\Program Files\Meson\;C:\Strawberry\c\bin;C:\Strawberry\perl\site\bin;C:\Strawberry\perl\bin;C:\Users\AnonymousUser\AppData\Local\Microsoft\WindowsApps;C:\Program Files\Intel\WiFi\bin\;C:\Program Files\Common Files\Intel\WirelessCommon\;C:\Users\AnonymousUser\AppData\Local\Programs\Fiddler;C:\Users\AnonymousUser\AppData\Local\GitHubDesktop\bin;C:\Users\AnonymousUser\AppData\Local\atom\bin;C:\Users\AnonymousUser\AppData\Local\Microsoft\WindowsApps;C:\Users\AnonymousUser\AppData\Roaming\npm;C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin;C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja;C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\VC\Linux\bin\ConnectionManagerExe
# 
# TEMP=J:\tmp
# TMP=J:\tmp
# 
# R_ARCH=/x64
# R_HOME=C:\Program Files\R\R-4.2.3
# 
# PKG_CONFIG_PATH=J:\win\lib\pkgconfig
# PKG_CONFIG_SYSTEM_INCLUDE_PATH=J:\win\include
# PKG_CONFIG_SYSTEM_LIBRARY_PATH=J:\win\lib
# 
# type J:\win\lib\pkgconfig\libR.pc
# 
# rhome=/c/Program Files/R/R-4.2.3
# rarch=/x64
# prefix=${rhome}
# exec_prefix=${prefix}
# 
# r_libdir1x=${rhome}/bin${rarch}
# r_libdir2x=${rhome}/lib${rarch}
# rincludedir=${rhome}/include
# 
# Name: libR
# Description: R as a library
# Version: 4.2.3
# Libs: -fopenmp   -L${r_libdir1x} -L${r_libdir2x} -lR
# Cflags: -I${rincludedir} -I${rincludedir}
# Libs.private:
# 
# only places plr.lib is PLACED (EXISTS)
# SKIP THIS ONE ** J:\win\lib **
# J:\win\lib\x64
# 
# Run-time dependency libr found: YES 4.2.3
# Detected in "meson setup" when R.lib DOES NOT EXIST ANYWHERE
# Best deal just leave it JUST ONE in the J:\win\lib\x64" folder.
# 
# cd "J:\postgres-REL_16_BETA2"
# 
# rmdir /S /Q build
# 
# rem use DOUBLE QUOTES INSTEAD OF SINGLE QUOTES
# rem readline is disabled, -Dextra_version=_VISUAL_STUDIO
# 
# meson setup --backend vs --prefix "J:\PGINSTALL" -Drversion=4.2.3 -DR_HOME="C:\Program Files\R\R-4.2.3" -DR_ARCH="/x64" -Dbuildtype=release -Db_pie=true -Dnls=disabled -Dplperl=disabled -Dplpython=disabled -Dpltcl=disabled -Dicu=disabled -Dllvm=disabled -Dlz4=disabled -Dzstd=disabled -Dgssapi=disabled -Dldap=disabled -Dpam=disabled -Dbsd_auth=disabled -Dsystemd=disabled -Dbonjour=disabled -Dlibxml=disabled -Dlibxslt=disabled -Dreadline=disabled -Dzlib=disabled -Dextra_version=_VISUAL_STUDIO -Ddocs=disabled -Ddocs_pdf=disabled -Dcassert=false -Dtap_tests=disabled -Db_coverage=false -Ddtrace=disabled build
# 
# rem Run-time dependency libr found: YES 4.2.3 (GOOD)
# 
# meson compile -C build -v 
# 
#    221>Done Building Project "J:\postgres-REL_16_BETA2\build\src\test\modules\test_shm_mq\b46f08c@@test_shm_mq@sha.vcxproj" (default targets).
#      1>Done Building Project "J:\postgres-REL_16_BETA2\build\postgresql.sln" (default targets).
# 
# Build succeeded.
# 
#        "J:\postgres-REL_16_BETA2\build\postgresql.sln" (default target) (1) ->
#        "J:\postgres-REL_16_BETA2\build\src\timezone\d05ab38@@tzdata@cus.vcxproj" (default target) (32) ->
#        (CustomBuild target) ->
#          C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Microsoft\VC\v170\Microsoft.CppCommon.targets(248,5): warning MSB8065: Custom build for item "J:\postgres-REL_16_BETA2\
#        build\meson-private\custom_target.rule" succeeded, but specified output "j:\postgres-rel_16_beta2\build\src\timezone\timezone" has not been created. This may cause incremental build to
#        work incorrectly. [J:\postgres-REL_16_BETA2\build\src\timezone\d05ab38@@tzdata@cus.vcxproj]
# 
# 
#        "J:\postgres-REL_16_BETA2\build\postgresql.sln" (default target) (1) ->
#        "J:\postgres-REL_16_BETA2\build\contrib\plr\c0649f9@@plr@sha.vcxproj" (default target) (139) ->
#        (ClCompile target) ->
#          J:\postgres-REL_16_BETA2\contrib\plr\pg_conversion.c(1823,10): warning C4068: unknown pragma 'Rf_warning' [J:\postgres-REL_16_BETA2\build\contrib\plr\c0649f9@@plr@sha.vcxproj]
# 
# 
#        "J:\postgres-REL_16_BETA2\build\postgresql.sln" (default target) (1) ->
#        "J:\postgres-REL_16_BETA2\build\contrib\plr\c0649f9@@plr@sha.vcxproj" (default target) (139) ->
#        (Link target) ->
#          LINK : warning LNK4044: unrecognized option '/fopenmp'; ignored [J:\postgres-REL_16_BETA2\build\contrib\plr\c0649f9@@plr@sha.vcxproj]
# 
#     3 Warning(s)
#     0 Error(s)
# 
# Time Elapsed 00:03:27.35
# 
# J:\postgres-REL_16_BETA2>
# 
# meson test -C build --num-processes 1 -v --suite setup --suite plr
# 
# 3/3 postgresql:plr / plr/regress          RUNNING
# 
# >>>
# PG_REGRESS=J:\postgres-REL_16_BETA2\build\src/test\regress\pg_regress.exe
# REGRESS_SHLIB=J:\postgres-REL_16_BETA2\build\src/test\regress\regress.dll
# PATH=J:/postgres-REL_16_BETA2/build/tmp_install/PGINSTALL/bin;J:\postgres-REL_16_BETA2\build\contrib\plr;C:\ProgramData\chocolatey\bin;C:\Program
# Files\R\R-4.2.3\bin\x64;C:\Strawberry\perl\bin;C:\ProgramData\chocolatey\bin;C:\Program
# Files\Microsoft Visual
# Studio\2022\Community\VC\Tools\MSVC\14.36.32532\bin\HostX64\x64;C:\Program
# Files\Microsoft Visual
# Studio\2022\Community\Common7\IDE\VC\VCPackages;C:\Program
# Files\Microsoft Visual
# Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\TestWindow;C:\Program
# Files\Microsoft Visual
# Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team
# Explorer;C:\Program Files\Microsoft Visual
# Studio\2022\Community\MSBuild\Current\bin\Roslyn;C:\Program
# Files\Microsoft Visual Studio\2022\Community\Team
# Tools\Performance Tools\x64;C:\Program Files\Microsoft
# Visual Studio\2022\Community\Team Tools\Performance
# Tools;C:\Program Files (x86)\Microsoft
# SDKs\Windows\v10.0A\bin\NETFX 4.6.1 Tools\x64\;C:\Program
# Files (x86)\Windows Kits\10\bin\10.0.22621.0\\x64;C:\Program
# Files (x86)\Windows Kits\10\bin\\x64;C:\Program
# Files\Microsoft Visual
# Studio\2022\Community\\MSBuild\Current\Bin\amd64;C:\Windows\Microsoft.NET\Framework64\v4.0.30319;C:\Program
# Files\Microsoft Visual
# Studio\2022\Community\Common7\IDE\;C:\Program
# Files\Microsoft Visual
# Studio\2022\Community\Common7\Tools\;C:\ActiveTcl\bin;C:\Python310\Scripts\;C:\Python310\;C:\Users\AnonymousUser\AppData\Local\Android\Sdk\platform-tools;C:\Program
# Files\Amazon
# Corretto\jdk11.0.16_8\bin;C:\gtk+-bundle_3.6.4-20130513_win64\bin;C:\Program
# Files\NVIDIA GPU Computing Toolkit\CUDA\v10.1\bin;C:\Program
# Files\NVIDIA GPU Computing
# Toolkit\CUDA\v10.1\libnvvp;W:\Oracle19cC\bin;W:\Oracle19cB\bin;W:\Oracle19cA\bin;C:\Program
# Files\Git\bin;C:\Program Files
# (x86)\sox-14-4-2;C:\ProgramFiles\MIT\Kerberos\bin;C:\Program
# Files\Perforce\;C:\WINDOWS\System32\OpenSSH\;C:\Program
# Files\Gource\cmd;C:\Program Files\TortoiseSVN\bin;C:\Program
# Files\doxygen\bin;C:\WINDOWS;C:\WINDOWS\system32;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\;C:\Program
# Files\dotnet\;C:\Program
# Files\LLVM\bin;C:\ProgramData\Anaconda3;C:\Python27;C:\Users\AnonymousUser\AppData\Local\bin\NASM;W:\depot_tools;C:\Program
# Files (x86)\Windows
# Kits\10\Debuggers\x64;C:\Users\AnonymousUser\scoop\shims;C:\OTHERBIN;C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\;C:\WINDOWS\System32\OpenSSH\;C:\Program
# Files (x86)\AOMEI\AOMEI Backupper\6.6.1;C:\Program Files
# (x86)\Intel\Intel(R) Management Engine
# Components\DAL;C:\Program Files\Intel\Intel(R) Management
# Engine Components\DAL;C:\Program
# Files\PuTTY\;C:\OTHERBIN\rclone-v1.59.0-windows-amd64;C:\flutter\bin;C:\Users\AnonymousUser\AppData\Local\Programs\Microsoft
# VS Code;C:\Program
# Files\nodejs\;C:\ProgramData\chocolatey\bin;C:\Program Files
# (x86)\Calibre2\;C:\Program Files
# (x86)\GitExtensions\;C:\Program
# Files\MiKTeX\miktex\bin\x64\;C:\Program Files (x86)\Windows
# Kits\10\Windows Performance Toolkit\;C:\Program
# Files\Meson\;C:\Strawberry\c\bin;C:\Strawberry\perl\site\bin;C:\Strawberry\perl\bin;C:\Users\AnonymousUser\AppData\Local\Microsoft\WindowsApps;C:\Program
# Files\Intel\WiFi\bin\;C:\Program Files\Common
# Files\Intel\WirelessCommon\;C:\Users\AnonymousUser\AppData\Local\Programs\Fiddler;C:\Users\AnonymousUser\AppData\Local\GitHubDesktop\bin;C:\Users\AnonymousUser\AppData\Local\atom\bin;C:\Users\AnonymousUser\AppData\Local\Microsoft\WindowsApps;C:\Users\AnonymousUser\AppData\Roaming\npm;C:\Program
# Files\Microsoft Visual
# Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin;C:\Program
# Files\Microsoft Visual
# Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja;C:\Program
# Files\Microsoft Visual
# Studio\2022\Community\Common7\IDE\VC\Linux\bin\ConnectionManagerExe
# PG_TEST_EXTRA= MALLOC_PERTURB_=219
# W:\depot_tools\python3.BAT
# J:\postgres-REL_16_BETA2\build\..\src/tools/testwrap
# --basedir J:\postgres-REL_16_BETA2\build --srcdir
# J:\postgres-REL_16_BETA2\contrib\plr --testgroup plr
# --testname regress --
# J:\postgres-REL_16_BETA2\build\src/test\regress\pg_regress.exe
# --inputdir J:\postgres-REL_16_BETA2\contrib\plr
# --expecteddir J:\postgres-REL_16_BETA2\contrib\plr --bindir
# --dlpath J:\postgres-REL_16_BETA2\build\contrib\plr
# --max-concurrent-tests=20 --dbname regression_plr
# --outputdir
# J:/postgres-REL_16_BETA2/build/testrun/plr/regress
# --temp-instance
# J:/postgres-REL_16_BETA2/build/testrun/plr/regress/tmp_check
# --port 40001 plr bad_fun opt_window do out_args
# plr_transaction opt_window_frame
# 
# 
# ▶ 3/3 - plr                                       740 ms OK
# ▶ 3/3 - bad_fun                                   254 ms OK
# ▶ 3/3 - opt_window                                261 ms OK
# ▶ 3/3 - do                                        252 ms OK
# ▶ 3/3 - out_args                                  271 ms OK
# ▶ 3/3 - plr_transaction                           280 ms OK
# ▶ 3/3 - opt_window_frame                          257 ms OK
# 3/3 postgresql:plr / plr/regress          OK               10.19s   7 subtests passed
# 
# 
# Ok:                 3
# Expected Fail:      0
# Fail:               0
# Unexpected Pass:    0
# Skipped:            0
# Timeout:            0
# 
# Full log written to J:\postgres-REL_16_BETA2\build\meson-logs\testlog.txt
# 
# J:\postgres-REL_16_BETA2>
# 
# J:\postgres-REL_16_BETA2>dir J:\postgres-REL_16_BETA2\build\contrib\plr
#  Volume in drive J is J_IMDISK__
#  Volume Serial Number is 54EF-E89D
# 
#  Directory of J:\postgres-REL_16_BETA2\build\contrib\plr
# 
# 07/17/2023  11:28 AM    <DIR>          .
# 07/17/2023  11:28 AM    <DIR>          ..
# 07/17/2023  11:28 AM            16,244 c0649f9@@plr@sha.vcxproj
# 07/17/2023  11:33 AM    <DIR>          c0649f9@@plr@sha
# 07/17/2023  11:33 AM            76,800 plr.dll
#                2 File(s)         93,044 bytes
#                3 Dir(s)   1,456,181,248 bytes free
# 
# J:\postgres-REL_16_BETA2>
# 
# 		<IntDir>c0649f9@@plr@sha\</IntDir>
# 		<TargetName>plr</TargetName>
# 		<TargetExt>.dll</TargetExt>
# 
# 			<AdditionalIncludeDirectories>c0649f9@@plr@sha;C:\Program Files\R\R-4.2.3\include;C:/Program Files/R/R-4.2.3/include;..\..\src\include;..\..\..\src/include;..\..\src\include\port\win32;..\..\..\src/include/port/win32;..\..\src\include\port\win32_msvc;..\..\..\src/include/port/win32_msvc;..\..\src\include\catalog;..\..\src\include\nodes;..\..\src\include\utils;..\..\src\include\storage;%(AdditionalIncludeDirectories);J:/win/include</AdditionalIncludeDirectories>
# 			<AdditionalDependencies>J:/win/lib/x64/R.lib;J:/postgres-REL_16_BETA2/build/src/backend/postgres.exe.lib;ws2_32.lib;kernel32.lib;user32.lib;gdi32.lib;winspool.lib;shell32.lib;ole32.lib;oleaut32.lib;uuid.lib;comdlg32.lib;advapi32.lib;%(AdditionalDependencies)</AdditionalDependencies>
# 
# 			<OutputFile>$(OutDir)plr.dll</OutputFile>
# 			<SubSystem>Windows</SubSystem>
# 			<ImportLibrary>plr.lib</ImportLibrary>
# 			<TargetMachine>MachineX64</TargetMachine>
# 
# 	<ItemGroup>
# 		<CustomBuild Include="..\..\..\src/port/win32ver.rc">
# 			<Command>&quot;C:\Program Files\Meson\meson.exe&quot; &quot;--internal&quot; &quot;exe&quot; &quot;--unpickle&quot; &quot;J:\postgres-REL_16_BETA2\build\meson-private\meson_exe_rcgen_a2b2bd7e13da5ba9749ade6d697bd226a8f75eed.dat&quot;</Command>
# 			<Outputs>c0649f9@@plr@sha\win32ver.rc;c0649f9@@plr@sha\win32ver.res</Outputs>
# 			<AdditionalInputs>J:\postgres-REL_16_BETA2\build\meson-private\meson_exe_rcgen_a2b2bd7e13da5ba9749ade6d697bd226a8f75eed.dat;J:\postgres-REL_16_BETA2\src/tools/rcgen</AdditionalInputs>
# 		</CustomBuild>
# 	</ItemGroup>
# 
# 	<ItemGroup>
# 		<None Include="..\..\..\contrib\plr\meson.build"/>
# 	</ItemGroup
# 
# rem DELETE FILES except the PROJECT.vcxproj J:\postgres-REL_16_BETA2\build\contrib\plr\plr.dll -NOT .vcxproj
# rem NEVER, DO NOT DELETE THE PROJECT
# 
# meson compile -C build -v contrib/plr/plr:shared_module
# ## meson compile -C build -v contrib
# 
# Link:
# C:\Program Files\Microsoft Visual
# Studio\2022\Community\VC\Tools\MSVC\14.36.32532\bin\HostX64\x64\link.exe
# /ERRORREPORT:QUEUE /OUT:".\plr.dll" /NOLOGO
# J:/win/lib/x64/R.lib "J:/postgre
# s-REL_16_BETA2/build/src/backend/postgres.exe.lib"
# ws2_32.lib kernel32.lib user32.lib gdi32.lib winspool.lib
# shell32.lib ole32.lib oleaut32.lib uuid.lib comdlg32.lib
# advapi32.lib kern el32.lib user32.lib gdi32.lib winspool.lib
# comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib
# uuid.lib odbc32.lib odbccp32.lib /MANIFEST
# /MANIFESTUAC:"level='asInvoker' uiAc cess='false'"
# /manifest:embed /PDB:".\plr.pdb" /SUBSYSTEM:WINDOWS /TLBID:1
# /RELEASE /DYNAMICBASE /NXCOMPAT /IMPLIB:"plr.lib"
# /MACHINE:X64 /OPT:REF /DLL /INCREMENTAL:NO /STACK:4194304
# /NOEXP -fopenmp /NOIMPLIB /DLL
# "c0649f9@@plr@sha\win32ver.res" "c0649f9@@plr@sha\plr.c.obj"
# "c0649f9@@plr@sha\pg_conversion.c.obj"
# "c0649f9@@plr@sha\pg_backend_support.c.obj"
# "c0649f9@@plr@sha\pg_userfuncs.c.obj"
# "c0649f9@@plr@sha\pg_rsupport.c.obj"
# 
#     2>LINK : warning LNK4044: unrecognized option '/fopenmp'; ignored [J:\postgres-REL_16_BETA2\build\contrib\plr\c0649f9@@plr@sha.vcxproj]
#     c0649f9@@plr@sha.vcxproj -> J:\postgres-REL_16_BETA2\build\contrib\plr\plr.dll
#   FinalizeBuildStatus:
#     Deleting file "c0649f9@@plr@sha\plr.tlog\unsuccessfulbuild".
#     Touching "c0649f9@@plr@sha\plr.tlog\plr.lastbuildstate".
# 2>Done Building Project "J:\postgres-REL_16_BETA2\build\contrib\plr\c0649f9@@plr@sha.vcxproj" (default targets).
# 1>Done Building Project "J:\postgres-REL_16_BETA2\build\postgresql.sln" (contrib\plr\c0649f9__plr_sha target(s)).

# END MSVC

fs = import('fs')

plr_sources = files(
  'plr.c',
  'pg_conversion.c',
  'pg_backend_support.c',
  'pg_userfuncs.c',
  'pg_rsupport.c',
)

plr_regress = [
  'plr',
  'bad_fun',
  'opt_window',
  'do',
  'out_args',
  'plr_transaction',
  'opt_window_frame',
]

is_msvc    = meson.get_compiler('c').get_id() == 'msvc'
#
is_gcc     = meson.get_compiler('c').get_id() == 'gcc'
is_windows = build_machine.system() == 'windows'
is_mingw   = is_windows and is_gcc

is_not_mingw_and_not_msvc = not is_mingw and not is_msvc
is_msvc_or_is_mingw       = is_mingw or is_msvc

R_home = get_option('R_HOME')
if R_home == ''
  error('One must supply: -DR_HOME=newvalue')
endif

R_arch = get_option('R_ARCH')
if is_msvc_or_is_mingw
  if R_arch == ''
    message('One has not supplied: -DR_ARCH=newvalue')
  endif
endif

if R_arch == '/x64'
  PlatformTarget = 'x64'
endif
if R_arch == '/i386'
  PlatformTarget = 'x86'
endif

rversion   = get_option('rversion')
if is_msvc_or_is_mingw 
  if rversion == ''
    error('One must supply: -Drversion=x.y.z')
  endif
endif

if  is_msvc \
      and   \
    rversion.version_compare('>=4.3.0')
    #
    error('Microsoft Visual C++ can not compile plr using R for Windows of versions 4.3.0 and greater.')
endif

if   is_msvc_or_is_mingw   \
       and                 \
     rversion.version_compare('>=2.12.0')  \

    # Compiler is ( "mingw" or "msvc" ) and the version of "R" is 2.12.0 or greater.
    # R for Windows is Sub-Architectures
    # (Note R 4.1.3 and greater is still Sub-Archectures with the 32bit part removed.)
    r_subarchitectures = true
else
    # Non Sub-Architecture anywhere else
    r_subarchitectures = false
endif

if not r_subarchitectures
  win_Rddl_path_nosubarch = R_home
endif
if     r_subarchitectures
  win_Rddl_path_subarch   = R_home / R_arch.substring(1)
endif
if not r_subarchitectures
  win_Rddl_path = win_Rddl_path_nosubarch
endif
if    r_subarchitectures
  win_Rddl_path = win_Rddl_path_subarch
endif

# #
# # meson MAY DO the right thing and I do not have to manually do this
# #
# if is_msvc
# 
#   # gendef - Can be from
#   # mingw-w64-???-tools-git
#   # https://packages.msys2.org/search?t=binpkg&q=tools-git
#   # How to use it
#   # https://sourceforge.net/p/mingw-w64/wik0i2/gendef/
#   #
#   # NOTE gendef.exe path and file must be known or available
#   #
#   # Unable to use custom_command for tools that only output to stdout #512
#   # https://github.com/mesonbuild/meson/issues/512
#   #
#   # maybe "dumpbin.exe" would also work?
#   custom_target('R def file', capture: true, command: [ 'gendef' ,'-' , win_Rddl_path / 'R.dll' ], output: win_Rddl_path / 'R.def')
# 
#   # msvc lib
#   # Target platform
#   # J:\Program Files\Microsoft Visual Studio\2022\Community>lib /?
#   # https://learn.microsoft.com/en-us/visualstudio/msbuild/msbuild-target-framework-and-target-platform?view=vs-2022
#   r = run_command('lib', '/def:' + win_Rddl_path / 'R.def', '/out:' + win_Rddl_path / 'R.lib', '/MACHINE:' + PlatformTarget)
# endif

plr_deps = []

# Best practice of using pkg-config in meson build system
# https://stackoverflow.com/questions/68931956/best-practice-of-using-pkg-config-in-meson-build-system
#
if is_not_mingw_and_not_msvc and fs.is_file('/lib/pkgconfig/libR.pc')
  message('pkg-config library libR exists.')
endif

dep_R =  dependency('', required : false)


dep_R = cc.find_library('R', required : false, dirs : ['deps/lib/pkgconfig'])
# #
# # NOTE "cc" is a meson variable from the file pg source code root "meson.build"
# #
# if is_not_mingw_and_not_msvc
#   # cygwin WORKS
#   dep_R = dependency('libR', required : false)
#   if not dep_R.found()
#     dep_R = cc.find_library('R', required: false, dirs : ['/usr/lib/R/bin','/usr/lib/R/lib'])
#     if not dep_R.found()
#       dep_R = cc.find_library('R', required: false, dirs : ['/usr/local/lib/R/bin','/usr/local/lib/R/lib'])
#     endif
#   endif
# endif
# 
# if is_msvc_or_is_mingw
#   # If I create my own libR.pc file
#   dep_R = dependency('libR', required : false)
#   if not dep_R.found()
#     # If I create my own libR.pc file, then THESE SHOULD never reached.
#     if not r_subarchitectures
#       # TODO if is_mingw, then meson create a "not R subarchitectures" pkg-config.pc
#       # TODO if is_msvc,  then meson create a "not R subarchitectures" cmake
#       # X dep_R = cc.find_library('libR', dirs: R_home / 'bin' ) X
#       dep_R = dependency('libR', required : false)
#     endif
#     if    r_subarchitectures
#       # TODO if is_mingw, then meson create a "R subarchitectures" pkg-config.pc
#       # TODO if is_msvc,  then meson create a "R subarchitectures" cmake
#       # actually only ever known to have "R Sub-Architectures" is on Windows      # Run-time dependency libr found: NO (tried pkgconfig and cmake)
#       # X dep_R = cc.find_library('libR', dirs: R_home / 'bin' / R_arch.substring(1)) # contrib/plr/meson.build:_LINE_:17: ERROR: C shared or static library 'libR' not found X
#       dep_R = dependency('libR', required : false)
#     endif
#   endif
# endif

if not dep_R.found()
  error('R library is not found.  Check R_HOME [and R_ARCH if applicable] [and rversion if applicable].')
endif

plr_deps +=  dep_R

# R library is not in a pkg-config (or "cmake" or "auto") location
# then I can either 
# (1) put where pkg-config can find it: pkg-config expected locations
# or
# (2) programmitically create it

# libR_dep = cc.find_library('R',  dirs : 'C:\RLIBS\R-4.2.3\bin\x64')
# plr_deps +=  libR_dep

plr_link_args = []
# args_R = '-lR'
args_R = []
plr_link_args += args_R

plr_link_with = []
# link_R = ['R'] # already in pkg-config Rlib.pc
link_R = []
plr_link_with += link_R

plr_incdir = []
R_incdir = include_directories(R_home / 'include')
plr_incdir += R_incdir

if host_system == 'windows'
  message('Detected host_system as windows.')
endif

if host_system == 'windows'
  plr_sources += rc_lib_gen.process(win32ver_rc, extra_args: [
    '--NAME', 'plr',
    '--FILEDESC', 'PL/R - PostgreSQL support for R as a procedural language (PLR)',])
endif

plr = shared_module('plr',
  plr_sources,
  link_args: plr_link_args,
  link_with: plr_link_with,
  c_pch: pch_postgres_h,
  include_directories: plr_incdir,
  kwargs: contrib_mod_args + {
    'dependencies': [plr_deps, contrib_mod_args['dependencies']]
  },
)

# COMPARE (TO SUCCESS)
#
# cygwin - make
# https://github.com/AndreMikulec/plr/blob/8613137fe46337a4d2067fc49a2a6d8295976b7b/Makefile
# result . .
# https://ci.appveyor.com/project/AndreMikulec/plr/builds/47456066/job/dywplxs87baufykh?fullLog=true#L9594
#
# gcc -Wall -Wmissing-prototypes -Wpointer-arith
# -Wdeclaration-after-statement -Werror=vla -Wendif-labels
# -Wmissing-format-attribute -Wimplicit-fallthrough=3
# -Wcast-function-type -Wshadow=compatible-local
# -Wformat-security -fno-strict-aliasing -fwrapv
# -fexcess-precision=standard -Wno-format-truncation
# -Wno-stringop-truncation -g -ggdb -Og -g3
# -fno-omit-frame-pointer -fvisibility=hidden -ggdb -Og -g3
# -fno-omit-frame-pointer -shared -o plr.dll
# -Wl,--out-implib=libplr.a plr.o pg_conversion.o
# pg_backend_support.o pg_userfuncs.o pg_rsupport.o
# -L/cygdrive/j/PGINSTALL/lib -Wl,--allow-multiple-definition
# -Wl,--enable-auto-import -L/usr/local/lib -Wl,--as-needed
# -fvisibility=hidden -L/usr/lib/R/bin -L/usr/lib/R/lib -lR
# -L/cygdrive/j/PGINSTALL/lib -lpostgres -lpgcommon -lpgport
# -lz -lreadline
#
# -- SUCCESS (SO FAR - BEFORE TESTS)
#
# cygwin - meson
#
# [1/6]
# cc -Icontrib/plr/plr.dll.p -I/usr/lib/R/include
# -Isrc/include -I../src/include -fdiagnostics-color=always
# -D_FILE_OFFSET_BITS=64 -Wall -Winvalid-pch -O3
# -fno-strict-aliasing -fwrapv -fexcess-precision=standard
# -D_GNU_SOURCE -Wmissing-prototypes -Wpointer-arith
# -Werror=vla -Wendif-labels -Wmissing-format-attribute
# -Wimplicit-fallthrough=3 -Wcast-function-type
# -Wshadow=compatible-local -Wformat-security
# -Wdeclaration-after-statement -Wno-format-truncation
# -Wno-stringop-truncation -pthread -fvisibility=hidden -MD
# -MQ contrib/plr/plr.dll.p/pg_backend_support.c.o -MF
# contrib/plr/plr.dll.p/pg_backend_support.c.o.d -o
# contrib/plr/plr.dll.p/pg_backend_support.c.o -c
# ../contrib/plr/pg_backend_support.c
#
# [2/6]
# cc -Icontrib/plr/plr.dll.p -I/usr/lib/R/include
# -Isrc/include -I../src/include -fdiagnostics-color=always
# -D_FILE_OFFSET_BITS=64 -Wall -Winvalid-pch -O3
# -fno-strict-aliasing -fwrapv -fexcess-precision=standard
# -D_GNU_SOURCE -Wmissing-prototypes -Wpointer-arith
# -Werror=vla -Wendif-labels -Wmissing-format-attribute
# -Wimplicit-fallthrough=3 -Wcast-function-type
# -Wshadow=compatible-local -Wformat-security
# -Wdeclaration-after-statement -Wno-format-truncation
# -Wno-stringop-truncation -pthread -fvisibility=hidden -MD
# -MQ contrib/plr/plr.dll.p/pg_userfuncs.c.o -MF
# contrib/plr/plr.dll.p/pg_userfuncs.c.o.d -o
# contrib/plr/plr.dll.p/pg_userfuncs.c.o -c
# ../contrib/plr/pg_userfuncs.c
#
# [3/6]
# cc -Icontrib/plr/plr.dll.p -I/usr/lib/R/include
# -Isrc/include -I../src/include -fdiagnostics-color=always
# -D_FILE_OFFSET_BITS=64 -Wall -Winvalid-pch -O3
# -fno-strict-aliasing -fwrapv -fexcess-precision=standard
# -D_GNU_SOURCE -Wmissing-prototypes -Wpointer-arith
# -Werror=vla -Wendif-labels -Wmissing-format-attribute
# -Wimplicit-fallthrough=3 -Wcast-function-type
# -Wshadow=compatible-local -Wformat-security
# -Wdeclaration-after-statement -Wno-format-truncation
# -Wno-stringop-truncation -pthread -fvisibility=hidden -MD
# -MQ contrib/plr/plr.dll.p/pg_rsupport.c.o -MF
# contrib/plr/plr.dll.p/pg_rsupport.c.o.d -o
# contrib/plr/plr.dll.p/pg_rsupport.c.o -c
# ../contrib/plr/pg_rsupport.c
#
# [4/6]
# cc -Icontrib/plr/plr.dll.p -I/usr/lib/R/include
# -Isrc/include -I../src/include -fdiagnostics-color=always
# -D_FILE_OFFSET_BITS=64 -Wall -Winvalid-pch -O3
# -fno-strict-aliasing -fwrapv -fexcess-precision=standard
# -D_GNU_SOURCE -Wmissing-prototypes -Wpointer-arith
# -Werror=vla -Wendif-labels -Wmissing-format-attribute
# -Wimplicit-fallthrough=3 -Wcast-function-type
# -Wshadow=compatible-local -Wformat-security
# -Wdeclaration-after-statement -Wno-format-truncation
# -Wno-stringop-truncation -pthread -fvisibility=hidden -MD
# -MQ contrib/plr/plr.dll.p/plr.c.o -MF
# contrib/plr/plr.dll.p/plr.c.o.d -o
# contrib/plr/plr.dll.p/plr.c.o -c ../contrib/plr/plr.c
#
# [5/6]
# cc -Icontrib/plr/plr.dll.p -I/usr/lib/R/include
# -Isrc/include -I../src/include -fdiagnostics-color=always
# -D_FILE_OFFSET_BITS=64 -Wall -Winvalid-pch -O3
# -fno-strict-aliasing -fwrapv -fexcess-precision=standard
# -D_GNU_SOURCE -Wmissing-prototypes -Wpointer-arith
# -Werror=vla -Wendif-labels -Wmissing-format-attribute
# -Wimplicit-fallthrough=3 -Wcast-function-type
# -Wshadow=compatible-local -Wformat-security
# -Wdeclaration-after-statement -Wno-format-truncation
# -Wno-stringop-truncation -pthread -fvisibility=hidden -MD
# -MQ contrib/plr/plr.dll.p/pg_conversion.c.o -MF
# contrib/plr/plr.dll.p/pg_conversion.c.o.d -o
# contrib/plr/plr.dll.p/pg_conversion.c.o -c
# ../contrib/plr/pg_conversion.c
#
# [6/6]
# cc -o contrib/plr/plr.dll contrib/plr/plr.dll.p/plr.c.o
# contrib/plr/plr.dll.p/pg_conversion.c.o
# contrib/plr/plr.dll.p/pg_backend_support.c.o
# contrib/plr/plr.dll.p/pg_userfuncs.c.o
# contrib/plr/plr.dll.p/pg_rsupport.c.o -Wl,--as-needed
# -Wl,--allow-shlib-undefined -Wl,-O1 -shared
# -Wl,--start-group -Wl,--out-implib=contrib/plr/plr.dll.a
# -fopenmp /usr/lib/R/lib/libR.dll.a -fvisibility=hidden
# /cygdrive/j/postgres-REL_16_BETA2/build/src/backend/libpostgres.exe.a
# -pthread /usr/lib/libssl.dll.a /usr/lib/libcrypto.dll.a -lm
# -lkernel32 -luser32 -lgdi32 -lwinspool -lshell32 -lole32
# -loleaut32 -luuid -lcomdlg32 -ladvapi32 -Wl,--end-group
#
# REGRESS_SHLIB=/cygdrive/j/postgres-REL_16_BETA2/build/src/test/regress/regress.dll
# PG_REGRESS=/cygdrive/j/postgres-REL_16_BETA2/build/src/test/regress/pg_regress.exe
# LD_LIBRARY_PATH=/cygdrive/j/postgres-REL_16_BETA2/build/tmp_install//cygdrive/j/PGINSTALL/lib
# MALLOC_PERTURB_=184 PG_TEST_EXTRA=''
# PATH=/cygdrive/j/postgres-REL_16_BETA2/build/tmp_install//cygdrive/j/PGINSTALL/bin:/cygdrive/j/postgres-REL_16_BETA2/build/contrib/plr:/usr/local/bin:/usr/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:.:/usr/lib/lapack
# /usr/bin/python3
# /cygdrive/j/postgres-REL_16_BETA2/build/../src/tools/testwrap
# --basedir /cygdrive/j/postgres-REL_16_BETA2/build --srcdir
# /cygdrive/j/postgres-REL_16_BETA2/contrib/plr --testgroup
# plr --testname regress --
# /cygdrive/j/postgres-REL_16_BETA2/build/src/test/regress/pg_regress.exe
# --inputdir /cygdrive/j/postgres-REL_16_BETA2/contrib/plr
# --expecteddir /cygdrive/j/postgres-REL_16_BETA2/contrib/plr
# --bindir '' --dlpath
# /cygdrive/j/postgres-REL_16_BETA2/build/contrib/plr
# --max-concurrent-tests=20 --dbname regression_plr
# --outputdir
# /cygdrive/j/postgres-REL_16_BETA2/build/testrun/plr/regress
# --temp-instance
# /cygdrive/j/postgres-REL_16_BETA2/build/testrun/plr/regress/tmp_check
# --port 40001 plr bad_fun opt_window do out_args
# plr_transaction opt_window_frame
#
# BEGIN NOTE
# In [6/6], the "cygwin R package manager" 
# 
# .1 provides "R" the static library "libR.dll.a"
# .2 provides that file in the default HOST pkg-config location: /usr/lib/[R][/lib]
# .3 SAME idea with the headers location 
# 
# cygwin meson
# in the cygwin libR.pc, is found 
# ```
# Libs: -fopenmp   -L${r_libdir1x} -L${r_libdir2x} -lR
# ```
# meson replaces in "meson build or compile (I am not sure which) using
# ```
# -fopenmp /usr/lib/R/lib/libR.dll.a
# ```

# SUCCESS (and TESTS)
# mingw meson R.lib can be R.dll Rlib.dll.a aks Rlib.a
# 
# [7/7] 
# "cc" -o contrib/plr/plr.dll
# contrib/plr/plr.dll.p/win32ver.obj
# contrib/plr/plr.dll.p/plr.c.obj
# contrib/plr/plr.dll.p/pg_conversion.c.obj
# contrib/plr/plr.dll.p/pg_backend _support.c.obj
# contrib/plr/plr.dll.p/pg_userfuncs.c.obj
# contrib/plr/plr.dll.p/pg_rsupport.c.obj
# "-Wl,--allow-shlib-undefined" "-Wl,-O1" "-shared"
# "-Wl,--start-group" "-Wl,--out
# -implib=contrib/plr/plr.dll.a" "-Wl,--stack,4194304"
# "-Wl,--allow-multiple-definition"
# "-Wl,--disable-auto-import" "-fopenmp"
# "C:/msys64PLR/ucrt64/bin/../lib/gcc/x86_64-w64-min
# gw32/13.1.0/../../../../lib/R.lib" "-fvisibility=hidden"
# "J:/postgres-REL_16_BETA2/build/src/backend/libpostgres.exe.a"
# "-pthread" "C:/msys64PLR/ucrt64/lib/libssl.dll.a" "C:/ms
# ys64PLR/ucrt64/lib/libcrypto.dll.a" "-lws2_32" "-lm"
# "-lkernel32" "-luser32" "-lgdi32" "-lwinspool" "-lshell32"
# "-lole32" "-loleaut32" "-luuid" "-lcomdlg32" "-ladvapi32"
# "-Wl,- -end-group"
# 
# REPLACED LINE TO
# "-fopenmp"
# "C:/msys64PLR/ucrt64/bin/../lib/gcc/x86_64-w64-mingw32/13.1.0/../../../../lib/R.lib"


# END NOTE

# AnonymousUser@ANONYMOUST /cygdrive/j/postgres-REL_16_BETA2
# $ meson test -C build --num-processes 1 -v --suite setup --suite plr
# ninja: no work to do.
# ninja: Entering directory `/cygdrive/j/postgres-REL_16_BETA2/build'
# ninja: no work to do.
# 1/1 postgresql:plr / plr/regress        RUNNING
# >>> REGRESS_SHLIB=/cygdrive/j/postgres-REL_16_BETA2/build/src/test/regress/regress.dll PG_REGRESS=/cygdrive/j/postgres-REL_16_BETA2/build/src/test/regress/pg_regress.exe LD_LIBRARY_PATH=/cygdrive/j/postgres-REL_16_BETA2/build/tmp_install//cygdrive/j/PGINSTALL/lib MALLOC_PERTURB_=184 PG_TEST_EXTRA='' PATH=/cygdrive/j/postgres-REL_16_BETA2/build/tmp_install//cygdrive/j/PGINSTALL/bin:/cygdrive/j/postgres-REL_16_BETA2/build/contrib/plr:/usr/local/bin:/usr/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:.:/usr/lib/lapack /usr/bin/python3 /cygdrive/j/postgres-REL_16_BETA2/build/../src/tools/testwrap --basedir /cygdrive/j/postgres-REL_16_BETA2/build --srcdir /cygdrive/j/postgres-REL_16_BETA2/contrib/plr --testgroup plr --testname regress -- /cygdrive/j/postgres-REL_16_BETA2/build/src/test/regress/pg_regress.exe --inputdir /cygdrive/j/postgres-REL_16_BETA2/contrib/plr --expecteddir /cygdrive/j/postgres-REL_16_BETA2/contrib/plr --bindir '' --dlpath /cygdrive/j/postgres-REL_16_BETA2/build/contrib/plr --max-concurrent-tests=20 --dbname regression_plr --outputdir /cygdrive/j/postgres-REL_16_BETA2/build/testrun/plr/regress --temp-instance /cygdrive/j/postgres-REL_16_BETA2/build/testrun/plr/regress/tmp_check --port 40001 plr bad_fun opt_window do out_args plr_transaction opt_window_frame
# ▶ 1/1 - plr                                      2387 ms OK
# ▶ 1/1 - bad_fun                                   980 ms OK
# ▶ 1/1 - opt_window                                928 ms OK
# ▶ 1/1 - do                                        806 ms OK
# ▶ 1/1 - out_args                                  849 ms OK
# ▶ 1/1 - plr_transaction                           855 ms OK
# ▶ 1/1 - opt_window_frame                        32863 ms OK
# 1/1 postgresql:plr / plr/regress        OK               83.64s   7 subtests passed
#
#
# Ok:                 1
# Expected Fail:      0
# Fail:               0
# Unexpected Pass:    0
# Skipped:            0
# Timeout:            0
#
# Full log written to /cygdrive/j/postgres-REL_16_BETA2/build/meson-logs/testlog.txt
#

# # pl_targets
# # part of a "language accumation list" that is passed into "install_quiet"
# # (but contrib_targets (below) is also passed into "install_quiet")
# pl_targets += plr
# # Possible benefit of moving(Junctioning) this folder into postgres/src/pl ?

contrib_targets += plr

install_data(
  'plr--8.4.5.sql',
  'plr--unpackaged--8.4.5.sql',
  'plr--8.3.0.18--8.4.sql',
  'plr--8.4.1--8.4.2.sql',
  'plr--8.4.3--8.4.4.sql',
  'plr--8.4--8.4.1.sql',
  'plr--8.4.2--8.4.3.sql',
  'plr--8.4.4--8.4.5.sql',
  'plr.control',
  kwargs: contrib_data_args,
)

tests += {
  'name': 'plr',
  'sd': meson.current_source_dir(),
  'bd': meson.current_build_dir(),
  'regress': {
    'sql': [
      plr_regress
    ],
  },
}
