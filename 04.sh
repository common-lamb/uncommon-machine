#!/usr/bin/env bash

set -e # Exit on error

echo "in 04.sh"
echo "Purpose: install emacs, emacs supporting packages, spacemacs"

# container does not source .profile or .bashrc
source ~/.bashrc

# emacs
# =====

guix install emacs emacs-age emacs-passage emacs-guix emacs-slime emacs-langtool emacs-calfw emacs-syncthing emacs-gptel

# daemon and start client
cat << 'EOF' >> ~/.bashrc

# start server
emacs --daemon

# alias to start client
  # start daemon if not already up
  # in current terminal
  # create a new frame only if none exists
alias e='emacsclient --alternate-editor='' --tty --reuse-frame'

EOF

echo "✓ Emacs"

# spacemacs
# =========

# fonts
guix install fontconfig font-adobe-source-code-pro font-fira-code
# refresh font cache
fc-cache -fv

#dependencies
guix install git tar ripgrep
# clone and pull develop branch
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
cd ~/.emacs.d
git checkout develop

# dotfile
cd ~/.uncommon-dotfiles
stow spacemacs

echo "see TODO: later update spacemacs and packages"
cat << 'EOF' >> ~/TODO

* TODO later update spacemacs and packages

# close emacs

cd ~/.emacs.d
git checkout develop
git pull --rebase

# restart emacs
# SPC f e U

EOF

# spacemacs support
guix install ispell tree-sitter

# first start will bootstrap (and approve compilation)
yes | emacs --daemon

echo "✓ spacemacs"
