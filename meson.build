

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

# expand postgres-REL_16_BETA2.zip to J:\postgres-REL_16_BETA2

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
#
# export R_HOME=/usr/lib/R && unset RTOOLS43_HOME
# export | grep R_HOME
#
# rem J is my RAMDISK
# rem C is permanent if I want a more permanent SOLUTION : --prefix /cygdrive/c/PGINSTALL
# note: - features - auto_features is enabled,  buildtype is "release", readline is enabled, PIE is true, -Dextra_version is _$(basename $(pwd))
#
# meson setup --prefix /cygdrive/j/PGINSTALL -Drversion=4.3.0 -DR_HOME='/usr/lib/R' -Dbuildtype=release -Db_pie=true -Dnls=disabled -Dplperl=disabled -Dplpython=disabled -Dpltcl=disabled -Dicu=disabled -Dllvm=disabled -Dlz4=disabled -Dzstd=disabled -Dgssapi=disabled -Dldap=disabled -Dpam=disabled -Dbsd_auth=disabled -Dsystemd=disabled -Dbonjour=disabled -Dlibxml=disabled -Dlibxslt=disabled -Dreadline=enabled -Dzlib=disabled -Dextra_version=_$(basename $(pwd)) -Ddocs=disabled -Ddocs_pdf=disabled -Dcassert=false -Dtap_tests=disabled -Db_coverage=false -Ddtrace=disabled build
#
# optionally run to change the --prefix
# meson configure --prefix /cygdrive/j/PGINSTALL

# "R for Windows"(msvc,mingw) + R and PLR (includes "readline")
# From the windows command prompt
# AnonymousUser@ANONYMOUST UCRT64 /j/postgres-REL_16_BETA2
#
# (NOTE: I MAY WANT TO RE-INSTALL R THIS AND PUT IT ON THE J DRIVE)
# MAKE SURE THAT NO SPACE EXISTS AT THE END OF THE "SET"
# set R_HOME=C:\Program Files\R\R-4.2.3
# set R_ARCH=/x64
# note - features SAME as above but DIFFERENT  -Dextra_version is _UCRT64
# meson setup -Drversion=4.2.3 -DR_HOME='C:\Program Files\R\R-4.2.3' -DR_ARCH='/x64' -Dbuildtype=release -Db_pie=true -Dnls=disabled -Dplperl=disabled -Dplpython=disabled -Dpltcl=disabled -Dicu=disabled -Dllvm=disabled -Dlz4=disabled -Dzstd=disabled -Dgssapi=disabled -Dldap=disabled -Dpam=disabled -Dbsd_auth=disabled -Dsystemd=disabled -Dbonjour=disabled -Dlibxml=disabled -Dlibxslt=disabled -Dreadline=enabled -Dzlib=disabled -Dextra_version=_UCRT64 -Ddocs=disabled -Ddocs_pdf=disabled -Dcassert=false -Dtap_tests=disabled -Db_coverage=false -Ddtrace=disabled build

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
# rem currenlty not used
# rem set MSYS_ARCH=x64
# 
# set  MSYS_ROOT=J:\msys64
# set MSYS_CACHE=J:\msys64\var\cache\setup
# 
# mkdir %MSYS_ROOT%
# mkdir %MSYS_ROOT%.Downloads
#
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
#
# https://github.com/msys2/msys2-installer

# rmdir /S /Q C:\msys64STARTER
# 
# rem --cache-path MUST BE pre-existing. (The program can not create it.)
# msys2-x86_64-20230526.exe --verbose --confirm-command --default-answer  --accept-licenses --no-size-checking --root C:\msys64STARTER --cache-path J:\msys64.Downloads install
# 
# create pacman configuration and DIRECTORIES for the FIRST TIME
# MUST BE DONE ON THE C drive - can not be done on the J drive
# https://www.msys2.org/wiki/MSYS2-installation/

# double click C:\msys64STARTER\msys2_shell.cmd
# C:\msys64STARTER\msys2_shell.cmd --help
# run to initialize the pacman support directories
# pacman --needed -S bash pacman pacman-mirrors msys2-runtime

# rmdir /S /Q J:\msys64
# xcopy C:\msys64STARTER     J:\msys64 /E /H /I
# IF CLAIMS THAT I AM OUT OF SPACE, THEN I AM REALLY OUT OF SPACE

# xcopy C:\msys64STARTER\var J:\msys64\var /E /H /I
# 
# # MSYS2 never requires Administrator permissions
# # double click J:\msys64\ucrt64.exe
# double click C:\msys64STARTER\msys2_shell.cmd

# NEEDED TO BE INSTALLED
# pacman --needed -S bash pacman pacman-mirrors msys2-runtime
# pacman -S --needed --noconfirm mingw-w64-ucrt-x86_64-pkg-config mingw-w64-ucrt-x86_64-curl git mingw-w64-ucrt-x86_64-meson mingw-w64-ucrt-x86_64-make mingw-w64-ucrt-x86_64-gcc tar gzip mingw-w64-ucrt-x86_64-readline mingw-w64-ucrt-x86_64-zlib mingw-w64-ucrt-x86_64-icu icu-devel git flex bison mingw-w64-ucrt-x86_64-perl mingw-w64-ucrt-x86_64-winpty p7zip tar zstd
#
# Total Download Size:   146.71 MiB
# Total Installed Size:  951.06 MiB (actually about 311 MB)

# Just manually double click (or run from the command line) 
# MSYS does not require Administrator Privs 
# J:\msys64.Downloads>C:\msys64STARTER\msys2_shell.cmd -ucrt64
# 

# END MSYS2


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
#
# NOTE "cc" is a meson variable from the file pg source code root "meson.build"
#
if is_not_mingw_and_not_msvc
  # cygwin WORKS
  dep_R = dependency('libR', required : false)
  if not dep_R.found()
    dep_R = cc.find_library('R', required: false, dirs : ['/usr/lib/R/bin','/usr/lib/R/lib'])
    if not dep_R.found()
      dep_R = cc.find_library('R', required: false, dirs : ['/usr/local/lib/R/bin','/usr/local/lib/R/lib'])
    endif
  endif
endif

if is_msvc_or_is_mingw
  if not r_subarchitectures
    dep_R = cc.find_library('libR', dirs: R_home)
  endif
  if    r_subarchitectures
    # actually only ever known to have "R Sub-Architectures" is on Windows
    dep_R = cc.find_library('libR', dirs: R_home / R_arch.substring(1))
  endif
endif

if not dep_R.found()
  error('R library is not found.  Check R_HOME [and R_ARCH if applicable] [and rversion if applicable].')
endif

plr_deps +=  dep_R


plr_link_args = []
# args_R = '-lR'
args_R = []
plr_link_args += args_R

plr_link_with = []
# link_R = ['R']
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
# make
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
# meson
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
