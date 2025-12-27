#!/bin/bash

# Purpose: Install Guix

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

# source the profile for guix/guix-daemon
GUIX_PROFILE=${HOME}/.config/guix/current;
if [[ -f "$GUIX_PROFILE/etc/profile" ]]; then
    source "$GUIX_PROFILE/etc/profile"
fi

#set locale to minimal
#start the daemon using its group
LC_ALL=C.UTF-8 /root/.config/guix/current/bin/guix-daemon --build-users-group=guixbuild &

# worked, now includes generation 2
#guix describe

guix install --verbosity=0 hello


# source the profile for applications
export GUIX_PROFILE="${HOME}/.guix-profile"
if [[ -f "$GUIX_PROFILE/etc/profile" ]]; then
    source "$GUIX_PROFILE/etc/profile"
fi

#set env for locales
guix install --fallback glibc-locales

export GUIX_LOCPATH=$GUIX_PROFILE/lib/locale

# export PATH="${HOME}/.config/guix/current/bin:$PATH"

hello
#=>Hello, world!

# get up-to-date packages and security updates.
guix pull
guix package -u 


echo "✓ Guix pulled"
