#!/usr/bin/env bash

set -e # Exit on error

echo "in 04.sh"
echo "Purpose: install emacs, emacs supporting packages, spacemacs"

# container does not source .profile or .bashrc
source ~/.bashrc

DATE=$(date -I)

: << 'DONE'
DONE

# emacs
# =====

guix install emacs emacs-age emacs-passage emacs-guix emacs-slime

echo "✓ Emacs"

: << 'BLOCK'

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



# dotfile
cd ~/.uncommon-dotfiles
stow spacemacs
# spacemacs # first start will bootstrap

# &&& plan
#
# check 03.sh results thouroughly
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
