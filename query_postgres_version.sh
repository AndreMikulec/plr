#!/bin/bash
set -x -v -e

psql -d postgres -c "SELECT version();"
psql -d postgres -c "SELECT current_setting('server_version_num') "server_version_num";"
