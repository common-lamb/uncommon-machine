#!/bin/bash

#
# Container Setup Script - Run INSIDE the Apptainer container with --fakeroot 
# Purpose: Install dotfiles, Guix, SBCL, shl, lish, lem, StumpWM 
#

set -e # Exit on error



# setup for guix that needs to occur after a logout-login
guix install glibc-locales
export GUIX_LOCPATH="$HOME/.guix-profile/lib/locale"

# Source for current session
export GUIX_PROFILE="${HOME}/.guix-profile"
if [[ -f "$GUIX_PROFILE/etc/profile" ]]; then
    source "$GUIX_PROFILE/etc/profile"
fi

export PATH="${HOME}/.config/guix/current/bin:$PATH"

echo "✓ Guix"

