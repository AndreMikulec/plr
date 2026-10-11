#!/usr/bin/env bash
set -xveo pipefail

sudo apt-get update -qq

# time consuming
# sudo apt-get upgrade -qq -y

cat /proc/cpuinfo
cat /etc/os-release
