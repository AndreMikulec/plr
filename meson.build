

# PLR is built as a "contrib" of postgres

# cygwin setup
# 
# rem "Command Prompt" -> Right Click -> Run As Administrator
# 
# mkdir "C:\cygwin64.Downloads"
# cd "C:\cygwin64.Downloads"
# 
# # Download the file "setup-x86_64.exe" from https://www.cygwin.com/install.html
# # Place the file into  "C:\cygwin64.Downloads"
# # Rename the file. 
# 
# set CYG_ARCH=x64
# set CYG_ROOT=C:\cygwin64
# set CYG_CACHE=C:\cygwin64\var\cache\setup
# set CYG_MIRROR=https://mirrors.kernel.org/sourceware/cygwin/
# 
# # Choose to install Cygwin into     "C:\cygwin64".
# # Choose to use the Cygwin cache at "C:\cygwin64.Downloads".
# setup-x86_64_3.4.7.exe -qnNdO -v -R "%CYG_ROOT%" -s "%CYG_MIRROR%" -l "%CYG_CACHE%"
# setup-x86_64_3.4.7.exe -qnNdO -R "%CYG_ROOT%" -s "%CYG_MIRROR%" -l "%CYG_CACHE%" -P cygrunsrv
# 
# rem IMPORTANT
# setup-x86_64_3.4.7.exe -qnNdO -R "%CYG_ROOT%" -s "%CYG_MIRROR%" -l "%CYG_CACHE%" -P pkg-config -P meson -P gendef
# 
# setup-x86_64_3.4.7.exe -qnNdO -R "%CYG_ROOT%" -s "%CYG_MIRROR%" -l "%CYG_CACHE%" -P gcc-core -P make -P tar -P gzip -P libreadline7 -P zlib -P icu-devel -P bison -P perl
# setup-x86_64_3.4.7.exe -qnNdO -R "%CYG_ROOT%" -s "%CYG_MIRROR%" -l "%CYG_CACHE%" -P flex -P libreadline-devel -P libssl-devel -P libxml2-devel -P libxslt-devel -P openldap-devel -P zlib-devel
# setup-x86_64_3.4.7.exe -qnNdO -R "%CYG_ROOT%" -s "%CYG_MIRROR%" -l "%CYG_CACHE%" -P libintl-devel -P libcrypt-devel
# setup-x86_64_3.4.7.exe -qnNdO -R "%CYG_ROOT%" -s "%CYG_MIRROR%" -l "%CYG_CACHE%" -P p7zip

# (currently debugging problem "R packages, except "base" are not availabe in R(plr)"- uninstalling to try to find the problem
# REM setup-x86_64_3.4.7.exe -qnNdO -R "%CYG_ROOT%" -s "%CYG_MIRROR%" -l "%CYG_CACHE%" -P postgresql-client -P postgresql -P postgresql-devel

# setup-x86_64_3.4.7.exe -qnNdO -R "%CYG_ROOT%" -s "%CYG_MIRROR%" -l "%CYG_CACHE%" -P libpq-devel
# setup-x86_64_3.4.7.exe -qnNdO -R "%CYG_ROOT%" -s "%CYG_MIRROR%" -l "%CYG_CACHE%" -P R -P R-debuginfo
# set SHELL=%CYG_ROOT%\bin\bash
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
# %SHELL% -login -c "PATH="""" CHERE_INVOKING=1 ""C:\cygwin64\bin\mintty.exe"" -i /Cygwin-Terminal.ico -"
# export PATH=/usr/local/bin:/usr/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:.:/usr/lib/lapack
# 
# Start the Cygwin command prompt METHOD 2 (BETTER)
#
# set PATH=
# set CHERE_INVOKING=1
# "C:\cygwin64\bin\mintty.exe" -i /Cygwin-Terminal.ico -

# Start the Cygwin command prompt METHOD 3 (from a current mintty)
# 
# $(cygpath "C:\cygwin64\bin\mintty.exe") -i /Cygwin-Terminal.ico &

# In minnty do
# mkdir       /cygdrive/c/tmp
# export  TMP=/cygdrive/c/tmp
# export TEMP=/cygdrive/c/tmp


# modify the libR.pc pkg-config file
# ----------------------------------
# 
# ### SEE Joe Conway's plr Makefile
# ### https://github.com/postgres-plr/plr/blob/3305e4fd2acf623744624f2b8f22f2e0076d94cf/Makefile
# 
# AnonymousUser@ANONYMOUST /cygdrive/c/postgres-master_e9f15bc_2307081419
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
# AnonymousUser@ANONYMOUST /cygdrive/c/postgres-master_e9f15bc_2307081419
# $ cp  /lib/pkgconfig/libR.pc  /lib/pkgconfig/libR.pc.original
# 
# AnonymousUser@ANONYMOUST /cygdrive/c/postgres-master_e9f15bc_2307081419
# $ vi  /lib/pkgconfig/libR.pc
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


# Of postgres 17devel or REL_16_BETA2 and later . . .
# In the file contrib\meson.build
# add this line "subdir('plr')" as the top subdir.
# 
# In the directory "contrib", create the subdirectory "plr".
# Place the contents of "https://github.com/postgres-plr/plr" there.

# cygwin + R and PLR

# $ echo ${PATH}
# /usr/local/bin:/usr/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:.
#
# cd `posgres source code` of postgres postgres-master_e9f15bc_2307081419 or REL_16_BETA2 and later 

# Of postgres 17devel (postgres-master_e9f15bc_2307081419) or REL_16_BETA2 and later . . .
# In the file contrib/meson.build
# add this line "subdir('plr')" as the top subdir.
# 
# In the directory "contrib", create the subdirectory "plr".
# Place the contents of "https://github.com/postgres-plr/plr" there.
#
# Append the contents of contrib/plr/meson_options.txt_root_additions
#  to the file `posgres source code`/meson_options.txt
# 

# From the Cygwin command prompt (July 11, 2023)
#
# Determine the installed version of R and write it ito the setup LINE below . . 
# R --version
# R version 4.3.0 (2023-04-21) -- "Already Tomorrow"
# 
#
# rm -Rf build 
#
# export R_HOME=/usr/lib/R
# unset RTOOLS43_HOME
# rem J is my RAMDISK
# rem C is permanent if I want a more permanent SOLUTION : --prefix /cygdrive/c/PGINSTALL
# note: readline is enabled
# meson setup --prefix /cygdrive/j/PGINSTALL -Drversion=4.3.0 -DR_HOME='/usr/lib/R' -Dbuildtype=release -Db_pie=true -Dnls=disabled -Dplperl=disabled -Dplpython=disabled -Dpltcl=disabled -Dicu=disabled -Dllvm=disabled -Dlz4=disabled -Dzstd=disabled -Dgssapi=disabled -Dldap=disabled -Dpam=disabled -Dbsd_auth=disabled -Dsystemd=disabled -Dbonjour=disabled -Dlibxml=disabled -Dlibxslt=disabled -Dreadline=enabled -Dzlib=disabled -Dextra_version=_$(pwd) -Ddocs=disabled -Ddocs_pdf=disabled -Dcassert=false -Dtap_tests=disabled -Db_coverage=false -Ddtrace=disabled build
#
# optionally run to change the --prefix 
# meson configure --prefix /cygdrive/c/PGINSTALL

# "R for Windows"(msvc,mingw) + R and PLR (includes "readline")
# From the windows command prompt
# set R_HOME=C:\Program Files\R\R-4.2.3
# set R_ARCH=/x64
# note readline is enabled
# meson setup -Drversion=4.2.3 -DR_HOME='C:\Program Files\R\R-4.2.3' -DR_ARCH='/x64' -Dbuildtype=release -Db_pie=true -Dnls=disabled -Dplperl=disabled -Dplpython=disabled -Dpltcl=disabled -Dicu=disabled -Dllvm=disabled -Dlz4=disabled -Dzstd=disabled -Dgssapi=disabled -Dldap=disabled -Dpam=disabled -Dbsd_auth=disabled -Dsystemd=disabled -Dbonjour=disabled -Dlibxml=disabled -Dlibxslt=disabled -Dreadline=enabled -Dzlib=disabled -Dextra_version=_$(pwd) -Ddocs=disabled -Ddocs_pdf=disabled -Dcassert=false -Dtap_tests=disabled -Db_coverage=false -Ddtrace=disabled build

# not this (because I must do a full build before an incremental build of just "plr")
#
# If these is NOT installed (and these MAY BE OLD)
# -P postgresql-client -P postgresql -P postgresql-devel
# and if this is ran
# meson compile -C build -v contrib/plr/plr:shared_module
# then later
# meson test -C build --num-processes 1 -v --suite setup
# ERROR: File 'src/port/libpgport.a' could not be found

# this
#
# meson compile -C build -v
# # (Meson test has no concept of pre-required "test", so this is an EnterprisDB working hack.)
# meson test -C build --num-processes 1 -v --suite setup 
# meson test -C build --num-processes 1 -v --suite plr
# now may be faster
# meson test -C build -num-processes 1 -v --suite plr

# after the full build
# if I forgot earlier to add the "plr" source folder, then
#
# AnonymousUser@ANONYMOUST /cygdrive/j/postgres-REL_16_BETA2
# $ meson test -C build --num-processes 1 -v --suite plr
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
# # no "re-setup" happens, just "plr compilaton" happens, so THIS IS FAST), 
# .4 run below
# meson test -C build --num-processes 1 -v --suite setup
# .5 run below
# meson test -C build --num-processes 1 -v --suite plr
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
# ../PGINSTALL/bin/pg_ctl -D /cygdrive/j/PGDATA -l logfile stop
# rm -Rf /cygdrive/j/PGDATA
# rm -Rf /cygdrive/j/PGINSTALL


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

# Best practice of using pkg-config in meson build system
# https://stackoverflow.com/questions/68931956/best-practice-of-using-pkg-config-in-meson-build-system
#
# Detect MinGW host #8776
# https://github.com/mesonbuild/meson/issues/8776
# each returns "windows"
# (quote: Cygwin is not identified as windows, so you don't have to worry about that. )
# 
# ANDRE verified JUL 2023
# "cygwin" - each DOES return "cygwin"
#
# host_system   = host_machine.system()
# build_system  = build_machine.system()
# target_system = target_machine.system()

is_msvc    = meson.get_compiler('c').get_id() == 'msvc'
#
is_gcc     = meson.get_compiler('c').get_id() == 'gcc'
is_windows = build_machine.system() == 'windows'
is_mingw   = is_windows and is_gcc
#
rversion   = get_option('rversion')

if rversion == ''
  error('One must supply: -Drversion=x.y.z')
endif


if is_msvc \
    and \
  rversion.version_compare('>=4.3.0')
  #
  error('Microsoft Visual C++ can not compile plr using R for Windows of versions 4.3.0 and greater.')
endif

if    is_mingw  \
      and \
      rversion.version_compare('>=2.12.0')  \
    or \
      is_msvc  \
      and \
      rversion.version_compare('>=2.12.0')
    #
    # Compiler is ( "mingw" or "msvc" ) and the version of "R" is 2.12.0 or greater.
    # R for Windows is Sub-Architectures
    # (Note R 4.1.3 and greater is still Sub-Archecture with the 32bit part removed.)
    r_subarchitectures = true
else
    # Non Sub-Architecture anywhere else
    r_subarchitectures = false
endif

# msvc lib 
# Target platform
# C:\Program Files\Microsoft Visual Studio\2022\Community>lib /?
# https://learn.microsoft.com/en-us/visualstudio/msbuild/msbuild-target-framework-and-target-platform?view=vs-2022

R_arch = get_option('R_ARCH')

if R_arch == ''
  message('One has not supplied: -DR_ARCH=newvalue')
endif


if R_arch == '/x64'
  PlatformTarget = 'x64'
endif
if R_arch == '/i386'
  PlatformTarget = 'x86'
endif


R_home = get_option('R_HOME')
if R_home == ''
  error('One must supply: -DR_HOME=newvalue')
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


if is_msvc

  # gendef - Can be from 
  # mingw-w64-???-tools-git
  # https://packages.msys2.org/search?t=binpkg&q=tools-git
  # How to use it
  # https://sourceforge.net/p/mingw-w64/wik0i2/gendef/
  #
  # gendef.exe path and file must be known or available
  #
  # Unable to use custom_command for tools that only output to stdout #512
  # https://github.com/mesonbuild/meson/issues/512
  #
  custom_target('R def file', capture: true, command: [ 'gendef' ,'-' , win_Rddl_path / 'R.dll' ], output: win_Rddl_path / 'R.def')

  # msvc lib 
  # Target platform
  # (BETTER) ALTERNATIVE use build_target ( export_dynamic xor implib )
  r = run_command('lib', '/def:' + win_Rddl_path / 'R.def', '/out:' + win_Rddl_path / 'R.lib', '/MACHINE:' + PlatformTarget)
endif

# Manually put "R" so the searcher can find it.
# option 1
# https://people.freedesktop.org/~dbn/pkg-config-guide.html
#
# https://www.msys2.org/docs/pkgconfig/
# https://www.cygwin.com/packages/summary/pkg-config.html
#
# You should generate a pkg-config
# pkgc = import('pkgconfig')
# Compiling D sources
# https://mesonbuild.com/D
# ALSO
# Pkgconfig module
# This module is a simple generator for pkg-config files.
# https://mesonbuild.com/Pkgconfig-module.html
#
# or
# option 2
# Some dependencies provide no valid methods for discovery
#   compiler.find_library()
#   https://mesonbuild.com/Reference-manual_returned_compiler.html#compilerfind_library
#   https://mesonbuild.com/Dependencies.html
#
# find_library example
# Release-notes-for-0.50.0.md
#
# find_library ldap example
# https://github.com/postgres/postgres/blob/9f6253613e8857942b1928bd7163bc1529fc9c69/meson.build#L682

plr_deps = []


dep_R = dependency('libR', required : true)

  # $ cat /lib/pkgconfig/libR.pc
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


# non-Windows and Windows
#
# # putting 
# # dep_R = dependency('libR', required : true)
# # and
# # dep_R
# # in root/meson.built WHEREVER zlib is found
#
# dep_R = dependency('libR', required : false)
# if not dep_R.found()
#   if not r_subarchitectures
#     message('Finding not R Sub-architectures libR')
#     # ERROR: C shared or static library 'libR' not found - cc.find_library('libR', dirs: R_home)
#     # ERROR: C shared or static library 'libR' not found -    find_library('libR', dirs: R_home)
#     dep_R = find_library('libR', dirs: R_home)
#   endif  
#   if    r_subarchitectures
#     # actually only ever known have "R Sub-Architectures" on Windows
#     message('Finding     R Sub-architectures libR')
#     dep_R = find_library('libR', dirs: R_home / R_arch.substring(1))
#   endif
#   if not dep_R.found()
#     error('R library is not found.  Check R_HOME [and R_ARCH if applicable].')
#   endif
# endif

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
# Different from "make",
# suprisingly "meson" "include_directories" does not recurse into subdirectories
# If I "do not" have this then R_ext "C" functions produce "wrong answers."
# R_incdir_R_ext = include_directories(R_home / 'include' / 'R_ext')
# plr_incdir += R_incdir_R_ext

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
  link_args: plr_link_args, # cannot find -lR: No such file or directory
  link_with: plr_link_with, # meson shared_module link_with - contrib/plr/meson.build:355:0: ERROR: 'R' is not a target.
  c_pch: pch_postgres_h,   
  include_directories: plr_incdir,
  kwargs: contrib_mod_args + {
    'dependencies': [plr_deps, contrib_mod_args['dependencies']]
  },
)

# COMPARE (TO SUCCESS)
# 
# https://ci.appveyor.com/project/AndreMikulec/plr/builds/47456066/job/pcph05t6u8nkxwg5?fullLog=true#L9540
# 
# gcc -Wall -Wmissing-prototypes -Wpointer-arith
# -Wdeclaration-after-statement -Werror=vla -Wendif-labels
# -Wmissing-format-attribute -Wimplicit-fallthrough=3
# -Wcast-function-type -Wformat-security -fno-strict-aliasing
# -fwrapv -fexcess-precision=standard -Wno-format-truncation
# -Wno-stringop-truncation -ggdb -O2 -pipe -Wall
# -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2
# -fstack-protector-strong --param=ssp-buffer-size=4 -shared
# -o plr.dll -Wl,--out-implib=libplr.a plr.o pg_conversion.o
# pg_backend_support.o pg_userfuncs.o pg_rsupport.o -L/usr/lib
# -Wl,-no-undefined -Wl,--allow-multiple-definition
# -Wl,--enable-auto-import -L/usr/local/lib -Wl,--as-needed
# -L/usr/lib/R/bin -L/usr/lib/R/lib -lR -L/usr/lib -lpostgres
# -lpgcommon -lpgport -lintl -lssl -lcrypto -lz -lreadline
# -lldap
# 
# -- SUCCESS (SO FAR - BEFORE TESTS)
# 
# [854/854] 
# cc -o contrib/plr/plr.dll contrib/plr/plr.dll.p/plr.c.o
# contrib/plr/plr.dll.p/pg_conversion.c.o
# contrib/plr/plr.dll.p/pg_backend_support.c.o
# contrib/plr/plr.dll.p/pg_userfuncs.c.o
# contrib/plr/plr.dll.p/pg_rsupport.c.o -Wl,--as-needed
# -Wl,--allow-shlib-undefined -Wl,-O1 -shared
# -Wl,--start-group -Wl,--out-implib=contrib/plr/plr.dll.a
# -fopenmp /usr/lib/R/lib/libR.dll.a -fvisibility=hidden
# /cygdrive/j/postgres-master_e9f15bc_2307081419/build/src/backend/libpostgres.exe.a
# -pthread /usr/lib/libssl.dll.a /usr/lib/libcrypto.dll.a -lm
# -lkernel32 -luser32 -lgdi32 -lwinspool -lshell32 -lole32
# -loleaut32 -luuid -lcomdlg32 -ladvapi32 -Wl,--end-group


# test plr.sql FAILS
#
# meson test -C build --num-processes 1 -v --suite setup
# meson test -C build --num-processes 1 -v --suite plr
# 
# ▶ 3/3 - plr                                      2030 ms FAIL
# ▶ 3/3 - bad_fun                                   962 ms OK
# ▶ 3/3 - opt_window                                965 ms OK
# ▶ 3/3 - do                                       1007 ms OK
# ▶ 3/3 - out_args                                  995 ms OK
# ▶ 3/3 - plr_transaction                          1045 ms OK
# ▶ 3/3 - opt_window_frame                          968 ms OK
# 3/3 postgresql:plr / plr/regress          ERROR            21.88s   exit status 1
# ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― ✀  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
# stderr:
# # 1 of 7 tests failed.
# # The differences that caused some tests to fail can be viewed in the file "/cygdrive/j/postgres-master_e9f15bc_2307081419/build/testrun/plr/regress/regression.diffs".
# # A copy of the test summary that you see above is saved in the file "/cygdrive/j/postgres-master_e9f15bc_2307081419/build/testrun/plr/regress/regression.out".
# 
# (test program exited with status code 1)
# ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
# 
# 
# Summary of Failures:
# 
# 3/3 postgresql:plr / plr/regress          ERROR            21.88s   exit status 1
# 
# Ok:                 2
# Expected Fail:      0
# Fail:               1
# Unexpected Pass:    0
# Skipped:            0
# Timeout:            0
# 
# Full log written to /cygdrive/j/postgres-master_e9f15bc_2307081419/build/meson-logs/testlog.txt
# 
# AnonymousUser@ANONYMOUST /cygdrive/j/postgres-master_e9f15bc_2307081419



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
