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

# # setup
# rclone config #make new @ db
# rclone lsd db:
# mkdir -p ~/db/1
# # start
# rclone mount db:1 ~/db/1 --vfs-cache-mode full &
# # stop
# cd ~ && fusermount -u ~/db/1

echo "✓ access"
