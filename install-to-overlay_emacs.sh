#!/bin/bash

# Purpose: install emacs, emacs supporting packages, spacemacs

set -e # Exit on error

# apptainer shell does not source .profile or .bashrc
source ~/.bashrc

DATE=$(date -I)

: << 'DONE'
DONE

# emacs 
# =====

# this is broken
# guix install --keep-going --fallback emacs 
# emacs-age emacs-passage emacs-guix emacs-slime 
#
#this is broken too
# apt install emacs

echo "✓ Emacs"

# spacemacs 
# =========

# fonts 
guix install fontconfig font-adobe-source-code-pro font-fira-code 
# refresh font cache
fc-cache -fv 

#dependencies
guix install git tar ripgrep 
# make way for the new install
[ -d $HOME/.emacs.d ] && mv $HOME/.emacs.d $HOME/.emacs.d.bak
[ -f $HOME/.emacs ] && mv $HOME/.emacs $HOME/.emacs.bak
[ -f $HOME/.emacs.el ] && mv $HOME/.emacs.el .emacs.el.bak
# clone and pull develop branch
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
cd ~/.emacs.d
git checkout develop


: << 'BLOCK'

# dotfile
cd ~/.uncommon-dotfiles
stow spacemacs
# spacemacs # first start will bootstrap

# &&& plan
# 
# run IIII without stow to generate default dotfile
# shell in and do first run
# generate default dotfile  
# add 
# mod
# push 
# run IIII with stow
# check mod is in place
#
# incrementally include dotfile components


# to update spacemacs and packages
# close emacs
# cd ~/.emacs.d
# git checkout develop
# git pull --rebase
# restart emacs
# SPC f e U

echo "✓ spacemacs"

# spacemacs support
# latex etc

# daemon and start client
# =======================
cat << 'EOF' >> ~/.bashrc

EOF

echo "✓ aaa"


echo "see TODO: rsync age key to this machine"
cat << EOF >> ~/TODO

* rsync copy age key to this machine

EOF

BLOCK
