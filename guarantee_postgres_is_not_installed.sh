#!/bin/bash
set -x -v -e

if [ -f "/etc/init.d/postgresql" ]
then
  sudo /etc/init.d/postgresql stop
fi

sudo apt-get remove --purge postgresql\*
sudo rm -rf /etc/postgresql /var/lib/postgresql

# Additionally, you will likely need to define a higher "pinning" priority 
#  as otherwise the versions of the packages provided 
#   by the operating system would be preferred (SEEN AUG 2026)
# https://wiki.postgresql.org/wiki/Apt/FAQ#Development_snapshots

sudo touch     /etc/apt/preferences.d/pgdg.pref
sudo chmod 777 /etc/apt/preferences.d/pgdg.pref
echo "
Package: \*
Pin: release o=apt.postgresql.org
Pin-Priority: 800
" >> /etc/apt/preferences.d/pgdg.pref
