#!/bin/bash

#
# Container Setup Script - Run INSIDE the Apptainer container with --fakeroot 
# Purpose: Install dotfiles, Guix, SBCL, shl, lish, lem, StumpWM 
#

set -e # Exit on error

echo "=== Container Environment Setup ===" 
whoami

# SYSTEM UPDATE
echo "--- Update/Upgrade package lists ---" 
apt update 
apt upgrade 
echo "✓ Updated"

# worked, basic description
#guix describe 

#set locale to minimal
#start the daemon using its group
LC_ALL=C.UTF-8 /root/.config/guix/current/bin/guix-daemon --build-users-group=guixbuild &

# source the profile
GUIX_PROFILE=${HOME}/.config/guix/current;
source "$GUIX_PROFILE/etc/profile"

# worked, now includes generation
#guix describe

guix install --verbosity=0 hello

export GUIX_PROFILE="${HOME}/.guix-profile"
if [[ -f "$GUIX_PROFILE/etc/profile" ]]; then
    source "$GUIX_PROFILE/etc/profile"
fi
export PATH="${HOME}/.config/guix/current/bin:$PATH"

hello
#=>Hello, world!

# get up-to-date packages and security updates.
guix pull
guix package -u 

echo "✓ Guix pulled"
