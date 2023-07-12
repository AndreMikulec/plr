

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
# setup-x86_64_3.4.7.exe -qnNdO -R "%CYG_ROOT%" -s "%CYG_MIRROR%" -l "%CYG_CACHE%" -P postgresql-client -P postgresql -P postgresql-devel
# setup-x86_64_3.4.7.exe -qnNdO -R "%CYG_ROOT%" -s "%CYG_MIRROR%" -l "%CYG_CACHE%" -P libpq-devel
# setup-x86_64_3.4.7.exe -qnNdO -R "%CYG_ROOT%" -s "%CYG_MIRROR%" -l "%CYG_CACHE%" -P R -P R-debuginfo
# set SHELL=%CYG_ROOT%\bin\bash
# %SHELL% -login -c "cygserver-config --yes"
# copy %CYG_ROOT%\etc\defaults\etc\cygserver.conf %CYG_ROOT%\etc\defaults\etc\cygserver.conf.original
# echo kern.ipc.shmmni 32767 >> %CYG_ROOT%\etc\defaults\etc\cygserver.conf
# echo kern.ipc.shmseg 32767 >> %CYG_ROOT%\etc\defaults\etc\cygserver.conf
# %SHELL% -login -c "cygrunsrv -S cygserver"
# cd "C:\"
# 

# Of postgres 17devel or REL_16_BETA2 and later . . .
# In the file contrib\meson.build
# add this line "subdir('plr')" as the top subdir.
# 
# In the directory "contrib", create the subdirectory "plr".
# Place the contents of "https://github.com/postgres-plr/plr" there.

# cygwin + R and PLR


# Start the Cygwin command prompt
#
# set PATH=
# set CHERE_INVOKING=1
# "C:\cygwin64\bin\mintty.exe -i /Cygwin-Terminal.ico -
# 
# $ echo ${PATH}
# /usr/local/bin:/usr/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:.
#
# cd `posgres source code` of postgres 17devel or REL_16_BETA2 and later 

# Of postgres 17devel or REL_16_BETA2 and later . . .
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
# export R_HOME=/usr/lib/R
# meson setup -Drversion=4.3.0 -DR_HOME='/usr/lib/R' -Dbuildtype=release -Db_pie=true -Dnls=disabled -Dplperl=disabled -Dplpython=disabled -Dpltcl=disabled -Dicu=disabled -Dllvm=disabled -Dlz4=disabled -Dzstd=disabled -Dgssapi=disabled -Dldap=disabled -Dpam=disabled -Dbsd_auth=disabled -Dsystemd=disabled -Dbonjour=disabled -Dlibxml=disabled -Dlibxslt=disabled -Dreadline=disabled -Dzlib=disabled -Dextra_version=_$(pwd) -Ddocs=disabled -Ddocs_pdf=disabled -Dcassert=false -Dtap_tests=disabled -Db_coverage=false -Ddtrace=disabled build

# "R for Windows"(msvc,mingw) + R and PLR
# From the windows command prompt
# set R_HOME=C:\Program Files\R\R-4.2.3
# set R_ARCH=/x64
# meson setup -Drversion=4.2.3 -DR_HOME='C:\Program Files\R\R-4.2.3' -DR_ARCH='/x64' -Dbuildtype=release -Db_pie=true -Dnls=disabled -Dplperl=disabled -Dplpython=disabled -Dpltcl=disabled -Dicu=disabled -Dllvm=disabled -Dlz4=disabled -Dzstd=disabled -Dgssapi=disabled -Dldap=disabled -Dpam=disabled -Dbsd_auth=disabled -Dsystemd=disabled -Dbonjour=disabled -Dlibxml=disabled -Dlibxslt=disabled -Dreadline=disabled -Dzlib=disabled -Dextra_version=_$(pwd) -Ddocs=disabled -Ddocs_pdf=disabled -Dcassert=false -Dtap_tests=disabled -Db_coverage=false -Ddtrace=disabled build


# meson compile -C build -v contrib/plr/plr:shared_module
# meson test --list --suite setup --suite plr
# # Ignore failures.  Test "setup" is pre-required setup/test.
# # Meson test has no concept of pre-required, so this is a working hack.
# meson test -C build -v --suite plr 2>/dev/null || true
# # succeed - but only useful if I change the SQL of a\the plr test(s)
# meson test -C build --no-rebuild --num-processes 4 -v --suite setup --suite plr
# # incremental plr/*.c file changing, rebuilding and re-testing
# meson test -C build -v --suite plr

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
is_gcc     = meson.get_compiler('c').get_id() == 'gcc'
is_windows = build_machine.system() == 'windows'
rversion   = get_option('rversion')

if rversion == ''
  error('One must supply: -Drversion=x.y.z')
endif


if is_windows \
    and \
  rversion.version_compare('>=4.3.0')
  #
  error('Microsoft Visual C++ can not compile plr using R for Windows of versions 4.3.0 and greater.')
endif

if    is_windows and is_gcc \
      and \
      rversion.version_compare('>=2.12.0')  \
    or \
      is_windows and is_msvc  \
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
  PlatformTarget == 'x64'
endif
if R_arch == '/i386'
  PlatformTarget == 'x86'
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


if is_windows and is_msvc

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
