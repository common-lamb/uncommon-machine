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
cd ~ && rm -r $temp
cd ~/.uncommon-dotfiles
stow lish

echo "✓ Lish"

# LEM
guix install lem

git clone https://github.com/fukamachi/.lem ~/.lem

mkdir -p ~/common-lisp && cd ~/common-lisp
git clone https://github.com/fukamachi/lem-vi-sexp.git

# cd ~/.uncommon-dotfiles
# stow lem
# &&& pick up and push fukamachi's config
# &&& remove the clone line activate the stow line

echo "✓ Lem"

# NYXT
# &&& timed out
# guix install nyxt emacs-nyxt
# cd ~/.uncommon-dotfiles
# stow nyxt

# echo "✓ Nyxt"

# STUMPWM

# git clone https://github.com/stumpwm/stumpwm-contrib.git ~/.config/stumpwm/modules
# git clone https://github.com/goose121/clx-truetype.git ~/quicklisp/local-projects/clx-truetype
# git clone https://github.com/landakram/stumpwm-prescient ~/quicklisp/local-projects/stumpwm-prescient

guix install stumpwm font-dejavu cl-dejavu font-awesome fontconfig

fc-cache -rv

cd ~/.uncommon-dotfiles
stow stumpwm

echo "✓ StumpWM"
