#!/usr/bin/env bash

set -e # Exit on error

echo "in 01.sh"
echo "Purpose: Install Guix, phase 1"

# basic description
guix describe

# source the profile for guix/guix-daemon
GUIX_PROFILE=${HOME}/.config/guix/current;
if [[ -f "$GUIX_PROFILE/etc/profile" ]]; then
    source "$GUIX_PROFILE/etc/profile"
fi

# in the image the group has already been created

#set locale to minimal
#start the daemon using its group
LC_ALL=C.UTF-8 /root/.config/guix/current/bin/guix-daemon --build-users-group=guixbuild &

# includes generation 2
guix describe

guix install --verbosity=0 hello

# source the profile for applications
export GUIX_PROFILE="${HOME}/.guix-profile"
if [[ -f "$GUIX_PROFILE/etc/profile" ]]; then
    source "$GUIX_PROFILE/etc/profile"
fi

# source the profile for applications sets this path
# export PATH="${HOME}/.config/guix/current/bin:$PATH"

#set env for locales
guix install --fallback glibc-locales

export GUIX_LOCPATH=$GUIX_PROFILE/lib/locale

hello
#=>Hello, world!

# get up-to-date packages and security updates.
guix pull
guix package -u

echo "✓ Guix pulled"
