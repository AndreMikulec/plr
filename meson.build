fs = import('filesystem')


plr_sources = files(
  'plr.c', 
  'pg_conversion.c',
  'pg_backend_support.c',
  'pg_userfuncs.c',
  'pg_rsupport.c',
)

plr_regress = [
  'plr',
  'plr_transaction',
  'bad_fun',
  'out_args'
  'opt_window',
  'opt_window_frame',
  'do',
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
plr_deps = []
dep_R = dependency('libR')
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
R_HOME = fs.parent(find_program('R'))
R_incdir = include_directories(join_paths(R_HOME, 'include'))
plr_incdir += R_incdir

if host_system == 'windows'
  plr_sources += rc_lib_gen.process(win32ver_rc, extra_args: [
    '--NAME', 'plr',
    '--FILEDESC', 'PL/R - PostgreSQL support for R as a procedural language (PL)',])
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