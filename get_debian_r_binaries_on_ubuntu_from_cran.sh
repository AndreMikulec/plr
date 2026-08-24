#!/bin/bash
set -x -v -e

# arm64 (i.e., M1/M2/M3, graviton etc) CPUs
# 24.04 (“noble”, amd64 and arm64),
# https://cloud.r-project.org/

# BASED ON "Joshua James" install scripts
# I only changed "apt" to "apt-get" plus parameters -qq and -y where appropriate

# How to Install R Lang on Ubuntu 26.04, 24.04 and 22.04
# Joshua James
# Wednesday, July 29, 2026 (SEEN AUG 2026)
# https://linuxcapable.com/how-to-install-r-lang-on-ubuntu-linux/
# 
# Ubuntu Packages For R - Brief Instructions
# However, only the latest LTS release is fully supported. 
# Recent releases are build for 
# amd64 (i.e., 64-bit Intel and AMD) and arm64 (i.e., M1/M2/M3, graviton etc) CPUs;
# 
# As of May 21, 2026 the supported releases are
# 
# 26.04 (“resolute”, amd64 and arm64),
# 24.04 (“noble”, amd64 and arm64),
# 22.04 (“jammy”, amd64 and arm64)
# 
# Note that ‘cran40’ denotes a binary compatibility break by the R 4.0.* release, 
# it does not install R 4.0.* but the current R 4.6.* series.
# 
# Ubuntu Packages For R - Full Instructions
# The Debian R packages are maintained by Dirk Eddelbuettel. 
# The Ubuntu packages are compiled for i386 and amd64 by Michael Rutter (marutter@gmail.com) 
# using scripts developed by Vincent Goulet. (SEEN AUG 2026)
# https://cran.r-project.org/bin/linux/ubuntu/fullREADME.html
# and
# https://cloud.r-project.org/bin/linux/ubuntu/


#  Install Current R from CRAN

# CRAN publishes Ubuntu packages for resolute, noble, and jammy. 
# The repository supports amd64 and arm64; at the time of validation, 
# it supplied R 4.6 packages. 

# First, download the signing key into an isolated GPG directory 
# and compare its complete fingerprint before writing anything to APT:

(
set -euo pipefail

expected_fingerprint="E298A3A825C0D65DFD57CBB651716619E084DAB9"
key_work_dir="$(mktemp -d)"
trap 'rm -rf -- "$key_work_dir"' EXIT
install -d -m 0700 "$key_work_dir/gnupg"

curl -fL --retry 3 --retry-delay 2 \
  -o "$key_work_dir/cran.asc" \
  https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc

actual_fingerprint="$(
  gpg --homedir "$key_work_dir/gnupg" \
    --show-keys --with-colons "$key_work_dir/cran.asc" |
    awk -F: '$1 == "fpr" {print $10; exit}'
)"

if [[ "$actual_fingerprint" != "$expected_fingerprint" ]]; then
  printf 'CRAN key fingerprint mismatch: %s\n' "$actual_fingerprint" >&2
  exit 1
fi

gpg --homedir "$key_work_dir/gnupg" --batch --yes \
  --dearmor --output "$key_work_dir/cran.gpg" \
  "$key_work_dir/cran.asc"
sudo install -d -m 0755 /etc/apt/keyrings
sudo install -m 0644 "$key_work_dir/cran.gpg" /etc/apt/keyrings/cran.gpg
printf 'Verified CRAN key: %s\n' "$actual_fingerprint"
)

# Create a release-specific DEB822 source. 
# The guards stop the command on an unsupported codename or architecture:

(
set -euo pipefail

release="$(lsb_release -cs)"
architecture="$(dpkg --print-architecture)"

case "$release" in
  resolute|noble|jammy) ;;
  *)
    printf 'Unsupported Ubuntu codename: %s\n' "$release" >&2
    false
    ;;
esac

case "$architecture" in
  amd64|arm64) ;;
  *)
    printf 'Unsupported CRAN architecture: %s\n' "$architecture" >&2
    false
    ;;
esac

printf '%s\n' \
  "Types: deb" \
  "URIs: https://cloud.r-project.org/bin/linux/ubuntu/" \
  "Suites: ${release}-cran40/" \
  "Components:" \
  "Architectures: ${architecture}" \
  "Signed-By: /etc/apt/keyrings/cran.gpg" |
  sudo tee /etc/apt/sources.list.d/cran.sources >/dev/null
)

# The cran40 suffix identifies the repository ABI introduced with R 4.0; 
#   it does not limit you to R 4.0. 

# inspect the candidate and origin
# apt-cache policy r-base-core
apt-cache policy r-base
apt-cache policy r-base-dev
# install R
sudo apt-get install -qq r-base -y
sudo apt-get install -qq r-base-dev -y
