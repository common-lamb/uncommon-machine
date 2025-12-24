#!/bin/bash

# Purpose: setup Guix second phase
# setup for guix that needs to occur after a logout-login
# and mirror in bashrc

set -e # Exit on error

# source the profile for guix/guix-daemon binary
GUIX_PROFILE=${HOME}/.config/guix/current;
if [[ -f "$GUIX_PROFILE/etc/profile" ]]; then
    source "$GUIX_PROFILE/etc/profile"
fi

#set env for locales
export GUIX_LOCPATH="$HOME/.guix-profile/lib/locale"

#set locale to minimal
#LC_ALL=C.UTF-8 /root/.config/guix/current/bin/
#
#start the daemon using its group
guix-daemon --build-users-group=guixbuild &

# Source the profile for installed applications
export GUIX_PROFILE="${HOME}/.guix-profile"
if [[ -f "$GUIX_PROFILE/etc/profile" ]]; then
    source "$GUIX_PROFILE/etc/profile"
fi

# mirror the preceeding in bashrc
cat << EOF >> ~/.bashrc
# source the profile for guix/guix-daemon binary
GUIX_PROFILE=${HOME}/.config/guix/current;
if [[ -f "$GUIX_PROFILE/etc/profile" ]]; then
    source "$GUIX_PROFILE/etc/profile"
fi

#set env for locales
export GUIX_LOCPATH="$HOME/.guix-profile/lib/locale"

#set locale to minimal
#LC_ALL=C.UTF-8 /root/.config/guix/current/bin/
#
#start the daemon using its group
guix-daemon --build-users-group=guixbuild &

# Source the profile for installed applications
export GUIX_PROFILE="${HOME}/.guix-profile"
if [[ -f "$GUIX_PROFILE/etc/profile" ]]; then
    source "$GUIX_PROFILE/etc/profile"
fi

#should reattempt, often fails &&&
#guix install glibc-locales

EOF

echo "✓ Guix"
