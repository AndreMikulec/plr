#!/bin/bash
set -x -v -e

# REL_19_ (from old notes)
# "build and install from source" does not add to the PATH
export PATH=/usr/local/pgsql/bin:$PATH
#### psql -d postgres -c "SELECT version();"
#### psql -d postgres -c "SELECT current_setting('server_version_num') "server_version_num";"

# psql -d postgres -c "SELECT version();"
# psql -d postgres -c "SELECT current_setting('server_version_num') "server_version_num";"
#
# 18 repo
# psql: error: connection to server on socket "/var/run/postgresql/.s.PGSQL.5432" failed: FATAL: no pg_hba.
# 
# This error happens because your client tool is trying to make a 
# TCP/IP loopback connection to localhost or an IP address instead of using the local Unix socket, 
# and the server's pg_hba.conf does not allow unencrypted connections for the user runner

# explicitly setting the host to an empty string or the socket directory
# psql -h /var/run/postgresql -U runner -d postgres
# or simply
# psql -U runner -d postgres

# CONCLUSION (but REL_19_ [NOT WORK] works?)
# psql -h /var/run/postgresql -U runner -d postgres -c "SELECT version();"
# psql -h /var/run/postgresql -U runner -d postgres -c "SELECT current_setting('server_version_num') "server_version_num";"

psql -h 127.0.0.1 -U runner -d postgres -c "SELECT version();"
psql -h 127.0.0.1 -U runner -d postgres -c "SELECT current_setting('server_version_num') "server_version_num";"

