


# cygwin
# meson configure
# 
#   Core options                    Default Value                     Possible Values                   Description
#   --------------                  -------------                     ---------------                   -----------
#   buildtype                       debug
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
  'out_args'
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

if is_windows \
  and \
  rversion.version_compare('>=4.3.0')
  error('Microsoft Visual C++ can not compile plr using R for Windows of versions 4.3.0 and greater.')
endif

if    is_windows and is_gcc \
      and \
      rversion.version_compare('>=2.12.0') 
    or
      is_windows' and is_msvc  \
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
if get_option('R_ARCH') == '/x64'
  PlatformTarget == 'x64'
endif
if get_option('R_ARCH') == '/i386'
  PlatformTarget == 'x86'
endif

if not r_subarchitectures
  win_Rddl_path_nosubarch = get_option('R_HOME')
endif
if r_subarchitectures
  win_Rddl_path_subarch   = get_option('R_HOME') / get_option('R_ARCH').substring(1)
endif

if not r_subarchitectures
  win_Rddl_pathfile = win_Rddl_path_nosubarch / 'R.dll'
endif
if r_subarchitectures
  win_Rddl_pathfile = win_Rddl_path_subarch   / 'R.dll'
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
  custom_target('R.def', capture: true, command: [ 'gendef' ,'-' , win_Rddl_pathfile ] ,output: 'R.def')

  # msvc lib 
  # Target platform
  r = run_command('lib', '/def:R.def', '/out:R.lib', '/MACHINE:' + PlatformTarget)
endif

# Manually put "R" so the searcher can find it.
# option 1
# https://people.freedesktop.org/~dbn/pkg-config-guide.html
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
dep_R = dependency('libR', required : false)
if not dep_R.found()
  if not r_subarchitectures
    dep_R = find_library('libR', dirs:  get_option('R_HOME'))
  endif  
  if    r_subarchitectures
    # actually only ever known have "R Sub-Architectures" on Windows
    dep_R = find_library('libR', dirs: get_option('R_HOME') / get_option('R_ARCH').substring(1))
  endif
  if not dep_R.found()
    error("R library is not found.  Check R_HOME [and R_ARCH if applicable].")
  endif
endif

else

plr_deps +=  dep_R





plr_link_with = []
link_R = 'R'
plr_link_with += link_R

plr_incdir = []
R_incdir = include_directories(join_paths(R_HOME, 'include'))
plr_incdir += R_incdir

if host_system == 'windows'
  plr_sources += rc_lib_gen.process(win32ver_rc, extra_args: [
    '--NAME', 'plr',
    '--FILEDESC', 'PL/R - PostgreSQL support for R as a procedural language (PLR)',])
endif

plr = shared_module('plr',
  plr_sources,
  link_with: plr_link_with,
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
      plr_regress,
    ],
  },