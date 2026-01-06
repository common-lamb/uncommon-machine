#!/bin/bash

# Purpose: Install Lisp stack: kitty, Lish, lem, nyxt, xpra stumpwm

set -e # Exit on error

# apptainer shell does not source .profile or .bashrc
source ~/.bashrc


# LEM
guix install lem 
#&&& ENV setting
git clone https://github.com/fukamachi/.lem ~/.lem 
mkdir -p ~/common-lisp/lem-vi-sexp 
git clone git@github.com:fukamachi/lem-vi-sexp ~/common-lisp/lem-vi-sexp
# cd ~/dotfiles &&& stow lem
echo "✓ Lem"


# NYXT
guix install nyxt nyxt-emacs 
cd ~/dotfiles 
stow nyxt 
echo "✓ Nyxt"



# INSTALL STUMPWM
guix install stumpwm xpra 
cd ~/dotfiles 
stow stumpwm 
#&&& remote setup 
cd ~/dotfiles 
stow xpra 
echo "✓ StumpWM"

# LISH 
guix install kitty
cd ~/dotfiles 
stow kitty 

temp="~/temp-lish"
mkdir -p ${temp} && cd ${temp} 
git clone https://github.com/common-lamb/yew.git
cd yew/lish

# may need to modify vars.lisp 
# search:path-append 
# (defun default-lishrc () (nos:path-append (nos:user-home) ".lishrc")) 
# ->
# (defun default-lishrc () (path-append (namestring (user-homedir-pathname)) ".lishrc"))

sh ./build.sh 
mv lish ~/.local/bin 
#cd ~/dotfiles stow lish 
# https://codeberg.org/nibbula/yew/src/branch/master/lish/docs/lish-examples.md 
# over work vpn? does not like windows remote access
echo "✓ Lish"
