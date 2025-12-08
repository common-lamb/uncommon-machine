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

# &&& worked
#apt update 
#apt upgrade 
echo "✓ Updated"

# setup GUIX

# create a group and user for the daemon to use (already done in pulled image)
# groupadd --system guix-daemon
#useradd -g guix-daemon -G guix-daemon               \
          #-d /var/empty -s $(which nologin)          \
          #-c "Guix daemon privilege separation user" \
          #--system guix-daemon
	  #

# worked to show fail
echo $(guix install hello)

# worked
guix describe 

LC_ALL=C.UTF-8 

#start the daemon using its group
# supposed to be here
/root/.config/guix/current/bin/guix-daemon --build-users-group=guixbuild &

# browsed to find here in image
#/var/guix/profiles/per-user/root/current-guix/bin/guix-daemon # worked as root
#/var/guix/profiles/per-user/root/current-guix/bin/guix-daemon --build-users-group=guixbuild & # worked

guix install --verbosity=0 hello
echo "early exit"
exit 0

GUIX_PROFILE=/root/.config/guix/current;
. "$GUIX_PROFILE/etc/profile"

guix describe
#=>Generation 2	Nov 28 2025 10:14:11	(current)  guix c9eb69d    repository URL: https://gitlab.com/debdistutils/guix/mirror.git    branch: master    commit: c9eb69ddbf05e77300b59f49f4bb5aa50cae0892

guix install --verbosity=0 hello
#=> accepted connection from pid 55, user rootThe following package will be installed:   hello 2.12.2

GUIX_PROFILE="/root/.guix-profile"
. "$GUIX_PROFILE/etc/profile"

hello
#=>Hello, world!

#guix pull

echo "✓ Guix pulled &&&"

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

