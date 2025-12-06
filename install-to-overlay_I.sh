#!/bin/bash

  #
  # Container Setup Script - Run INSIDE the Apptainer container with --fakeroot Purpose: Install dotfiles, Guix, SBCL, shl, lish, lem, StumpWM 
  # and Emacs
  #

  set -e # Exit on error

  echo "=== Container Environment Setup ===" whoami

  # SYSTEM UPDATE
  echo "" 
  echo "--- Update/Upgrade package lists ---" 
  apk update 
  apk upgrade 
  echo "✓ Updated"


  # INSTALL GUIX
  apk add guix


addgroup -S guix-daemon

adduser \
  -h /var/empty \
  -g "Guix daemon privilege separation user" \
  -s $(which nologin) \
  -S \
  -G guix-daemon \
  guix-daemon

# apk add openrc # &&& make proper service
guix-daemon --build-users-group=guixbuild &

guix pull




  # we need to logout-login, so go to install II
