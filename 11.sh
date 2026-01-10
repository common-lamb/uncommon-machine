#!/usr/bin/env bash

set -e # Exit on error

echo "in 11.sh"
echo "Purpose: graphics and styling"

# container does not source .profile or .bashrc
source ~/.bashrc

# fresh dots
cd ~/.uncommon-dotfiles
git fetch
git pull

#install compositor, backgrounder
guix install picom feh

cd ~/.uncommon-dotfiles
stow feh
stow background
echo "✓ background"

guix install xscreensaver xlockmore flameshot

echo "see TODO: maybe setup screen lock and screen saver"
cat << 'EOF' >> ~/TODO

* TODO setup screen lock and screen saver

# screen saver

# run in background
xscreensaver -nosplash &
# settings
xscreensaver-settings
# pick one screensaver (Gleideoscope) and ensure lock is deactivated!
# start
xscreensaver-command --activate
# xscreensaver-command --lock #do not use on guix!


# screen lock

# on first use, enter password
xlock

EOF

# &&& set XTERM etc

echo "✓ graphics"

# hostname
# hostnamectl set-hostname uncommon-machine
# hostnamectl

# system info
# keyboard
guix install neofetch kmonad

# palette
# &&& lunaria light palette
