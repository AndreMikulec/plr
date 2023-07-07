

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

# THESE TO MAKE IT BUILD
#
# link_with path:**/meson.build
# https://github.com/search?q=link_with+path%3A**%2Fmeson.build&type=code
#
# shared_module path:**/meson.build
# https://github.com/search?q=shared_library+path%3A**%2Fmeson.build&type=code

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
host_system   = host_machine.system()
# build_system  = build_machine.system()
# target_system = target_machine.system()

if host_machine.system() == 'windows' and meson.get_compiler('c').get_id() == 'msvc' \
  and \
  get_option('rversion').version_compare('>=4.3.0')
  error('Microsoft Visual C++ can not compile plr using R for Windows of versions 4.3.0 and greater.')
endif


# Manually put "R" so the searcher can find it.
# option 1
# https://people.freedesktop.org/~dbn/pkg-config-guide.html
# or
# option 2
# Some dependencies provide no valid methods for discovery
#  compiler.find_library()
#  https://mesonbuild.com/Reference-manual_returned_compiler.html#compilerfind_library
# https://mesonbuild.com/Dependencies.html
# find_library example
# Release-notes-for-0.50.0.md
# find_library ldap example
# https://github.com/postgres/postgres/blob/9f6253613e8857942b1928bd7163bc1529fc9c69/meson.build#L682

if meson.get_compiler('c').get_id() == 'msvc'
  # mingw gendef
  # gendef . . . run it
  # gendef.exe - "$(R_HOME)\bin\$(rbin)\R.dll" &gt; R$(PlatformTarget).def

  # msvc lib 
  # lib   . . . run it
endif

plr_deps = []

if    host_machine.system() == 'windows' and meson.get_compiler('c').get_id() == 'gcc' \
      and \
      get_option('rversion').version_compare('>=2.12.0') 
    or
      host_machine.system() == 'windows' and meson.get_compiler('c').get_id() == 'msvc' \
      and \
      get_option('rversion').version_compare('>=2.12.0')
    # Compiler is ( "mingw" or "msvc" ) and the version of "R" is 2.12.0 or greater.
    # R for Windows Sub-Architectures
    # (Note R 4.1.3 and greater is still Sub-Archecture with the 32bit part removed.)
    dep_R = dependency('libR', required : false)
    if not dep_R.found()
      dep_R = find_library('libR', dirs: join_paths (get_option('R_HOME'), get_option('R_ARCH').substring(1)))
      if not dep_R.found()
        error("R library is not found.  Check R_HOME and R_ARCH.")
      endif
    endif
else
    # Non Sub-Architecture anywhere else
    dep_R = dependency('libR', required : false)
    if not dep_R.found()
      dep_R = find_library('libR', dirs:  get_option('R_HOME'))
      if not dep_R.found()
        error("R library is not found.  Check R_HOME.")
      endif
    endif
endif

plr_deps +=  dep_R

# #
# DANGER - both "mingw" nad "msvc" can be detected
# #
#
# Details for vsenv 
# The --vsenv argument is supported since 0.60.0, 
# -Dvsenv=true syntax is supported since 1.1.0.
# 
# Since 0.59.0, meson automatically activates a Visual Studio environment on Windows 
# for all its subcommands, but only if no other compilers (e.g. gcc or clang) are found, 
# and silently continues if Visual Studio activation fails.
# 
# Setting the vsenv option to true forces Visual Studio activation 
# even when other compilers are found. 
# It also make Meson abort with an error message when activation fails.
# 
# vsenv is true by default when using the vs backend.
# 
# Seen July 2023
# https://mesonbuild.com/Builtin-options.html
#
# Meson with MSVC on GitHub Actions
# 
# since this is what it detects by default in the GitHub Actions Environment. 
# running Meson on GitHub Actions will end up using GCC rather than MSVC
# His fix . . .
# 
#     - name: Prepare MSVC
#       uses: bus1/cabuild/action/msdevshell@v1
#       with:
#         architecture: x64
#     - name: Prepare Build
#       run: meson setup build
#     - name: Run Build
#       run: meson compile -v -C build
#     - name: Run Test Suite
#       run: meson test -v -C build
# 
# Meson with MSVC on GitHub Actions
# Written by David Rheinsberg, on April 21, 2021.
# Seen July 2023
# https://dvdhrm.github.io/2021/04/21/meson-msvc-github-actions/

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

# if you wish to generate Visual Studio project files, pass --backend vs.
# https://mesonbuild.com/Using-with-Visual-Studio.html


plr_link_with = []
link_R = 'R'
plr_link_with += link_R

# https://wiki.postgresql.org/wiki/Meson

# find "${R_HOME}/include" in the 
# (1) detected because of PATH of R.exe 
# (2) well known PLATFORM specific PATH to R
# figure this out myself

plr_incdir = []
# No, let the Developer provide this information
# R_HOME = fs.parent(find_program('R'))
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

pl_targets += plr

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