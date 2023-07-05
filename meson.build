

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
#   TODO test that 
host_system   = host_machine.system()
# build_system  = build_machine.system()
# target_system = target_machine.system()

plr_deps = []
# default
dep_R = dependency('libR', required : get_option('R_HOME'))

# DANGER - both "mingw" nad "msvc" can be detected
#
# Meson with MSVC on GitHub Actions
# Written by David Rheinsberg, on April 21, 2021.
# Seen July 2023
# https://dvdhrm.github.io/2021/04/21/meson-msvc-github-actions/
#
if host_machine.system() == 'windows' and meson.get_compiler('c').get_id() == 'gcc' and get_option('rversion').version_compare('>=2.12.0')
   or
   host_machine.system() == 'windows' and meson.get_compiler('c').get_id() == 'msvc' and get_option('rversion').version_compare('>=2.12.0')
  # override - compiler is ( "mingw" or "msvc" ) and the version of "R" is 2.12.0 or greater
  dep_R = dependency('libR', required : join_paths( get_option('R_HOME'), get_option('R_ARCH') ) )
endif

if host_machine.system() == 'windows' and meson.get_compiler('c').get_id() == 'msvc' and get_option('rversion').version_compare('>=4.3.0')
  message('Microsoft Visual C++ can not compile plr using R for Windows of versions 4.3.0 and greater.')
endif


# if you wish to generate Visual Studio project files, pass --backend vs.
# https://mesonbuild.com/Using-with-Visual-Studio.html


plr_deps +=  dep_R

plr_link_with = []
link_R = ['R']
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

plr = shared_library('plr',
  plr_sources,
  link_with: plr_link_with,
  c_pch: pch_postgres_h,
  include_directories: plr_incdir,
  kwargs: contrib_mod_args + {
    'dependencies': [plr_deps, contrib_mod_args['dependencies']]
  },
)
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