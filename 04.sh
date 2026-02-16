#!/usr/bin/env bash

set -e # Exit on error

echo "in 04.sh"
echo "Purpose: install emacs, emacs supporting packages, spacemacs"

# container does not source .profile or .bashrc
source ~/.bashrc

# fresh dots
cd ~/.uncommon-dotfiles
git fetch
git pull

# fonts

guix install fontconfig font-adobe-source-code-pro font-fira-code
# forced refresh font cache
fc-cache -rv

# set locale and lang
# solves special characters in spacemacs
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export LANGUAGE=C.UTF-8

cat << 'EOF' >> ~/.bashrc

# set locale and lang
# solves special characters in spacemacs
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export LANGUAGE=C.UTF-8

EOF

# emacs
# =====

guix install emacs-lucid emacs-age emacs-passage emacs-guix emacs-slime emacs-langtool emacs-calfw emacs-syncthing emacs-gptel emacs-pdf-tools

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
# lsp layer uses npm
apt-get install -y npm

# first start will bootstrap (and approve compilation)
yes | emacs --daemon

echo "✓ spacemacs"
