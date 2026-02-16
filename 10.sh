#!/usr/bin/env bash

set -e # Exit on error

echo "in 10.sh"
echo "Purpose: data storage redundancy and access"

# container does not source .profile or .bashrc
source ~/.bashrc

# fresh dots
cd ~/.uncommon-dotfiles
git fetch
git pull

guix install mergerfs mergerfs-tools snapraid
echo "✓ storage"

guix install borg borgmatic
echo "✓ redundancy"

guix install rclone syncthing nextcloud-client cryfs
echo "✓ access"
