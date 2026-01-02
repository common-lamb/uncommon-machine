#!/usr/bin/env bash

set -e # Exit on error

echo "00.sh"
echo "Purpose: Pull image"

# SYSTEM UPDATE
echo "--- Update/Upgrade package lists ---"
apt-get update
apt-get upgrade
echo "✓ Updated"

#useful report
whoami
pwd
hostname
ls
