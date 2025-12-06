#!/bin/bash

  #
  # Container Setup Script - Run INSIDE the Apptainer container with --fakeroot 
  # Purpose: Install dotfiles, Guix, SBCL, shl, lish, lem, StumpWM 
  #

  set -e # Exit on error

  echo "=== Container Environment Setup ===" whoami

  # SYSTEM UPDATE
  echo "" 
  echo "--- Update/Upgrade package lists ---" 



#export DEBIAN_FRONTEND=noninteractive
#export TZ=Etc/UTC


  apk update 
  apk upgrade 
  apk add bash
  echo "✓ Updated"

## INSTALL GUIX
#apk add guix

## create a group and user for the daemon to use
#addgroup -S guix-daemon

#adduser \
  #-h /var/empty \
  #-g "Guix daemon privilege separation user" \
  #-s $(which nologin) \
  #-S \
  #-G guix-daemon \
  #guix-daemon

## start the daemon with its group
#guix-daemon --build-users-group=guixbuild & # &&& make proper service with: apk add openrc
## update, fails on containterizec ubuntu and alpine
#guix pull

# we need to logout-login for the remaining guix install steps 
# go to install II
# for now I have brought all guix here

#guix install glibc-locales
#export GUIX_LOCPATH="$HOME/.guix-profile/lib/locale"

## Add Guix to PATH
#echo 'export PATH="/root/.config/guix/current/bin:$PATH"' >> /root/.bashrc
#echo 'export GUIX_PROFILE="/root/.guix-profile"' >> /root/.bashrc
#echo 'source "$GUIX_PROFILE/etc/profile"' >> /root/.bashrc
## Source for current session
#export PATH="/root/.config/guix/current/bin:$PATH"
#export GUIX_PROFILE="/root/.guix-profile"
#if [[ -f "$GUIX_PROFILE/etc/profile" ]]; then
    #source "$GUIX_PROFILE/etc/profile"
#fi

## cleanup
#rm -f /tmp/guix-install.sh

#echo "✓ Guix"

