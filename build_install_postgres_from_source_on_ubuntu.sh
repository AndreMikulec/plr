#!/bin/bash
set -x -v -e

# r-base-dev and r-base
# Ubuntu Packages For R - Full Instructions
# 
# 26.05 (“resolute”, amd64 and arm64),
# 24.04 (“noble”, amd64 and arm64),
# 22.04 (“jammy”, amd64 and arm64)
# complete R system - r-base
# need to compile R packages from source - r-base-dev
# https://cran.r-project.org/bin/linux/ubuntu/fullREADME.html
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9

# remote .deb package or an uninstalled package in your repository
#
# view the full control information, including the Depends line
apt-cache show r-base-dev
#
# see a structured list of direct dependencies and pre-dependencies
apt-cache depends r-base-dev
#
# # recursively list all dependent packages down the chain
# apt-rdepends r-base-dev

# provides to PostgreSQL package libreadline-dev
# sudo apt-get install -qq r-base-dev -y
sudo apt-get install -qq libreadline-dev -y

# # package.deb file
# # (or dpkg -I)
#
# # inspect the package metadata and read the Depends: field
# dpkg-deb -I <path-to-package.deb>
# # print only the depends-on line
# dpkg-deb -f <path-to-package.deb>

# installed package
#
# view the full metadata of the installed package (including "Depends:" line)
apt show r-base-dev

# find the packages that an installed Ubuntu package depends on
apt depends r-base-dev

# query the local package database directly without touching the network
dpkg -s r-base-dev | grep '^Depends:'

# recursive list (the dependencies of the dependencies, all the way down),
sudo apt-get -qq install apt-rdepends -y
apt-rdepends r-base-dev

sudo apt-get install -qq bison flex libssl-dev -y

pushd postgres
./configure
make
sudo make install
popd
export PATH=/usr/local/pgsql/bin:$PATH
initdb -D data
pg_ctl -D data -l logfile start
