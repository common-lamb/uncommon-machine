#!/usr/bin/env bash

set -e # Exit on error

echo "00.sh"
echo "Purpose:locale, os update"

# set locale and lang
# solves special characters in spacemacs
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export LANGUAGE=C.UTF-8

touch ~/.bashrc
cat << 'EOF' >> ~/.bashrc

# set locale and lang
# solves special characters in spacemacs
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export LANGUAGE=C.UTF-8

EOF

# SYSTEM UPDATE
echo "--- Update/Upgrade package lists ---"
apt-get update
apt-get upgrade

echo "✓ Updated"

# useful report
# whoami
# pwd
# hostname
# ls
