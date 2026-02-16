#!/usr/bin/env bash

set -e # Exit on error

echo "in 08.sh"
echo "Purpose: Lisp tools: Lish, lem, nyxt, stumpw"

# container does not source .profile or .bashrc
source ~/.bashrc

# fresh dots
cd ~/.uncommon-dotfiles
git fetch
git pull

# LISH
guix install file # for libmagic
# https://codeberg.org/nibbula/yew/src/branch/master/lish/docs/lish-examples.md
temp="${HOME}/temp-lish"
mkdir -p ${temp} && cd ${temp}
git clone https://github.com/common-lamb/yew.git
cd yew/lish
sh ./build.sh
mv lish ~/.local/bin
cd ~ && rm -r ${temp}
cd ~/.uncommon-dotfiles
stow lish

echo "✓ Lish"

# LEM
guix install lem fd libvterm

echo "✓ Lem"

# NYXT

# echo "✓ Nyxt"

# STUMPWM

guix install stumpwm font-dejavu cl-dejavu font-awesome fontconfig
# forced refresh font cache
fc-cache -rv

# stumpwm contrib and modules
mkdir -p ~/.stumpwm.d/contrib
mkdir -p ~/.stumpwm.d/modules
git clone https://github.com/stumpwm/stumpwm-contrib ~/.stumpwm.d/contrib

cd ~/common-lisp
git clone https://github.com/goose121/clx-truetype.git
git clone https://github.com/landakram/stumpwm-prescient

cd ~/.uncommon-dotfiles
stow stumpwm

echo "✓ StumpWM"
