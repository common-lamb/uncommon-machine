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


# patches &&& move to 12

# solves special characters in spacemacs
cat << 'EOF' >> ~/.bashrc

# set locale and lang
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export LANGUAGE=C.UTF-8

EOF

# &&&untested install miniforge
guix install wget

mkdir ~/temp-conda && cd ~/temp-conda
wget -O Miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3.sh -b -p "${HOME}/conda"
cd ~ && rm -r ~/temp-conda

source "${HOME}/conda/etc/profile.d/conda.sh"
source "${HOME}/conda/etc/profile.d/mamba.sh"

conda activate
