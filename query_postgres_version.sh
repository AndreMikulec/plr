#!/bin/bash
set -x -v -e

# "runner" needs to find psql
# REL_XX_/master  "build and install from source" does not add this to the PATH.
# -rwxr-xr-x 1 root root 1121648 Aug 25 08:18 /usr/local/pgsql/bin/psql
# export PATH=/usr/local/pgsql/bin:$PATH
# (PG XY repo using"sudo -u postgres psql" does not need the above PATH addition)
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

# CONCLUSION (but REL_19_ [WORKS] works)
# psql -h 127.0.0.1 -U runner -d postgres -c "SELECT version();"
# psql -h 127.0.0.1 -U runner -d postgres -c "SELECT current_setting('server_version_num') "server_version_num";"
# psql: connection to server at "127.0.0.1", port 5432 failed: FATAL:  role "runner" does not exist
# THIS WORKS 18 repo | REL_19_ psql: error: connection to server at "127.0.0.1", port 5432 failed: FATAL:  role "postgres" does not exist
# psql -h 127.0.0.1 -U postgres -d postgres -c "SELECT version();"
# psql -h 127.0.0.1 -U postgres -d postgres -c "SELECT current_setting('server_version_num') "server_version_num";"
# 18 repo --  psql: error: connection to server at "127.0.0.1", port 5432 failed: FATAL:  role "runner" does not exist
# REL_19_ -- 
# psql -h 127.0.0.1 -d postgres -c "SELECT version();"
# psql -h 127.0.0.1 -d postgres -c "SELECT current_setting('server_version_num') "server_version_num";"

# "XX repo": Github Actions running account is "runner".  REL_XX_/master does not require this variable setting.
# REL_19_ -- psql: error: connection to server at "127.0.0.1", port 5432 failed: FATAL:  role "postgres" does not exist
# export PGUSER=postgres
# psql -h 127.0.0.1 -d postgres -c "SELECT version();"
# psql -h 127.0.0.1 -d postgres -c "SELECT current_setting('server_version_num') "server_version_num";"

# XX repo PGUSER is "runner"
# REL_XX_ PGUSER is "postgres"
# psql -h 127.0.0.1 -U postgres -d postgres -c "SELECT version();" || true
# psql -h 127.0.0.1 -U runner   -d postgres -c "SELECT version();" || true
# psql -h 127.0.0.1 -U postgres -d postgres -c "SELECT current_setting('server_version_num') "server_version_num";" || true
# psql -h 127.0.0.1 -U runner   -d postgres -c "SELECT current_setting('server_version_num') "server_version_num";" || true

# sudo -u postgres psql -c "SELECT version();" || true
# sudo -u postgres psql -c "SELECT current_setting('server_version_num') "server_version_num";" || true

# Create a superuser named 'runner' with no password prompt
# sudo -u postgres createuser -s -d -r -w runner
# sudo PATH=/usr/local/pgsql/bin:${PATH} -U postgres psql -c "CREATE ROLE runner WITH LOGIN SUPERUSER;"
# sudo PATH=/usr/local/pgsql/bin:${PATH} -U postgres psql -c "CREATE DATABASE runner OWNER runner;"
# Create a superuser named 'root' with no password prompt
# sudo -u postgres createuser -s -d -r -w root
# sudo PATH=/usr/local/pgsql/bin:${PATH} -U postgres psql -c "CREATE ROLE root WITH LOGIN SUPERUSER;"
# sudo PATH=/usr/local/pgsql/bin:${PATH} -U postgres psql -c "CREATE DATABASE root OWNER root;"

sudo -u postgres /usr/local/pgsql/bin/psql -U postgres -d postgres -c "CREATE ROLE runner WITH LOGIN SUPERUSER;"
sudo -u postgres /usr/local/pgsql/bin/psql -U postgres -d postgres -c "CREATE DATABASE runner OWNER runner;"
sudo -u postgres /usr/local/pgsql/bin/psql -U postgres -d postgres -c "CREATE ROLE root WITH LOGIN SUPERUSER;"
sudo -u postgres /usr/local/pgsql/bin/psql -U postgres -d postgres -c "CREATE DATABASE root OWNER runner;"

# looking for a database "runner", the same name as the user "runner"
/usr/local/pgsql/bin/psql -c "SELECT version();"
/usr/local/pgsql/bin/psql -c "SELECT current_setting('server_version_num') "server_version_num";"
