#!/bin/bash

# Purpose: Install Lisp foundation: SBCL, quicklisp, ultralisp, qlot, shl

set -e # Exit on error

# apptainer shell does not source .profile or .bashrc
source ~/.bashrc

: << 'BLOCK'
BLOCK

# fresh dots &&&
cd ~/.uncommon-dotfiles
git fetch
git pull

# sbcl
guix install sbcl
cd ~/.uncommon-dotfiles
stow sbcl
echo "✓ lisp"

# ql 
guix install curl
curl -o /tmp/quick.lisp http://beta.quicklisp.org/quicklisp.lisp 
sbcl --no-sysinit --no-userinit --load /tmp/quick.lisp --eval '(quicklisp-quickstart:install :path "~/quicklisp")' --eval '(ql:add-to-init-file)' --quit
echo "✓ quicklisp"

# ul
sbcl --eval '(ql-dist:install-dist "http://dist.ultralisp.org/" :prompt nil)' --quit 
echo "✓ ultralisp"

# shl
guix install sbcl rlwrap
cd ~/.uncommon-dotfiles 
stow shl 
echo "✓ shl"

# qlot
installation_path="/usr/local/lib/qlot"
mkdir -p ${installation_path}/bin
touch ${installation_path}/bin/qlot
chmod 755 ${installation_path}/bin/qlot
ln -sf ${installation_path}/bin/qlot ~/.local/bin/qlot
# &&& qlot startup options in emacs for M--
echo "✓ qlot (next)"
# this has to be the last line of the file, internally it exits when done
curl -L https://qlot.tech/installer | sh
