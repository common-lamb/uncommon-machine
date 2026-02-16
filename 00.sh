#!/usr/bin/env bash

set -e # Exit on error

echo "00.sh"
echo "Purpose:locale, os update"

# SYSTEM UPDATE
echo "--- Update/Upgrade package lists ---"
apt-get update
yes | apt-get upgrade

echo "✓ Updated"

# useful report
# whoami
# pwd
# hostname
# ls
