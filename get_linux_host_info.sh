#!/bin/bash
set -x -v -e

sudo apt-get update -qq

# time consuming
# sudo apt-get upgrade -qq -y

uname -a
uname -m
uname -o
cat /proc/cpuinfo
cat /etc/os-release
