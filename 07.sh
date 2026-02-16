#!/usr/bin/env bash

set -e # Exit on error

echo "in 07.sh"
echo "Purpose: Lisp foundation: SBCL, quicklisp, ultralisp, ocicl, shl"

# container does not source .profile or .bashrc
source ~/.bashrc

# fresh dots
cd ~/.uncommon-dotfiles
git fetch
git pull

mkdir -p ~/common-lisp/
mkdir -p ~/repos/

# sbcl
guix install sbcl
cd ~/.uncommon-dotfiles
stow sbcl
echo "✓ lisp"

# ql
guix install curl
curl -o /tmp/quick.lisp http://beta.quicklisp.org/quicklisp.lisp
yes | sbcl --no-sysinit --no-userinit --load /tmp/quick.lisp --eval '(quicklisp-quickstart:install :path "~/quicklisp")' --eval '(ql:add-to-init-file)' --quit
echo "✓ quicklisp"

# ul
sbcl --eval '(ql-dist:install-dist "http://dist.ultralisp.org/" :prompt nil)' --quit

echo "✓ ultralisp"

# shl
guix install sbcl rlwrap
cd ~/.uncommon-dotfiles
stow shl
echo "✓ shl"

# CFFI

# ;; Ref
# ;; https://lists.gnu.org/archive/html/bug-guix/2020-01/msg00133.html
# ;; https://lists.gnu.org/archive/html/bug-guix/2020-01/msg00133.html
# ;; https://notabug.org/Ambrevar/dotfiles/src/master/.sbclrc
# ;; https://www.reddit.com/r/GUIX/comments/10ju937/quicklisp_on_guix/

guix install openssl
# ls ${HOME}/.guix-profile/lib/ | grep "crypto"
# expect: libcrypto.so libcrypto.so.3

# some tools look to cffi:*foreign-library-directories*
# activate sbclrc section setting this
# which prints: ("/usr/lib/x86_64-linux-gnu/" "/root/.guix-profile/lib/")

# some tools look to LD_LIBRARY_PATH
export LD_LIBRARY_PATH=${HOME}/.guix-profile/lib/:$LD_LIBRARY_PATH

cat << 'EOF' >> ~/.bashrc

export LD_LIBRARY_PATH=${HOME}/.guix-profile/lib/:$LD_LIBRARY_PATH

EOF

# to expose the cffi error
# evaluate in shl: (ql:quickload :cl+ssl)
# or
# manually install qlot
# cd ~
# git clone https://github.com/fukamachi/qlot
# cd qlot
# echo "NEED TO SOLVE THE CFFI ERROR"
# scripts/setup.sh
# echo "SOLVED"
# scripts/install.sh

echo "✓ CFFI"

# qlot

# curl -L https://qlot.tech/installer | sh
# installation_path="/usr/local/lib/qlot"
# ln -s ${installation_path}/bin/qlot ~/.local/bin/qlot
# # use qlot startup options in emacs dotfile for M--
# echo "✓ qlot"

# ocicl
