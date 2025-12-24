#!/bin/bash

# Purpose: Install  Lips stack: SBCL, shl, lish, lem, StumpWM, Emacs

set -e # Exit on error

# apptainer shell does not source .profile or .bashrc
source ~/.bashrc

  # # INSTALL shl
  # guix install sbcl rlwrap cd ~/.uncommon-dotfiles stow shl echo "✓ shl"

  # # INSTALL ql and ul ql
  # curl -o /tmp/quick.lisp http://beta.quicklisp.org/quicklisp.lisp sbcl --no-sysinit --no-userinit --load /tmp/quick.lisp \
  #      --eval '(quicklisp-quickstart:install :path "~/quicklisp")' \ --eval '(ql:add-to-init-file)' \ --quit
  # echo "✓ quicklisp "
  # # ul
  # sbcl --eval '(ql-dist:install-dist "http://dist.ultralisp.org/" :prompt nil)' --quit echo "✓ ultralisp"

  # # INSTALL qlot
  # curl -L https://qlot.tech/installer | sh mv ~/.qlot/bin/qlot ~/.local/bin/
  # # &&& qlot startup options for M--

  # echo "✓ qlot"

  # # INSTALL STUMPWM
  # guix install stumpwm xpra cd ~/dotfiles stow stumpwm stow xpra #&&& remote setup echo "✓ StumpWM"

  # # NYXT
  # guix install nyxt nyxt-emacs cd ~/dotfiles stow nyxt echo "✓ Nyxt"

  # # LISH https://codeberg.org/nibbula/yew/src/branch/master/lish/docs/lish-examples.md over work vpn? does not like windows remote access
  # temp="~/temp-lish" mkdir -p ${temp} && cd ${temp} cd git clone https://codeberg.org/nibbula/yew.git cd yew/lish

  # # modify vars.lisp search:path-append (defun hide-default-lishrc () (nos:path-append (nos:user-home) ".lishrc")) (defun default-lishrc () 
  # # (path-append (namestring (user-homedir-pathname)) ".lishrc"))

  # sh ./build.sh mv lish ~/.local/bin cd ~/dotfiles stow lish echo "✓ Lish"

  # # LEM
  # guix install lem git clone https://github.com/fukamachi/.lem ~/.lem mkdir -p ~/common-lisp && cd ~/common-lisp git clone 
  # git@github.com:fukamachi/lem-vi-sexp
  # # cd ~/dotfiles &&& stow lem
  # echo "✓ Lem"

  # # EMACS
  # guix install emacs &&& spacemacs &&& dotfiles


  # &&& conda gwl

  # # INSTALL BASE DEPENDENCIES
  # echo "" echo "--- Installing base dependencies ---" apt-get install -y \
  #         wget \ curl \ git \ build-essential \ ca-certificates \ gnupg \ xz-utils

  # # INSTALL DEPENDENCIES
  # echo "" echo "--- Installing dependencies ---" apt-get install -y \
  #         expra \ emacs \

  # echo "✓ installed"

  # &&& expra
  # 
  # ################################################################################
  # # Create user password &&&
  # ################################################################################

  # echo "" echo "--- Cleaning up ---"

  # apt-get clean rm -rf /var/lib/apt/lists/*
  # ################################################################################
  # # SUMMARY
  # ################################################################################

  # echo "" echo "=== Setup Complete ===" echo "" echo "Installed software:" echo " - GNU Guix: $(guix --version | head -n1 || echo 'Check 
  # PATH')" echo " - SBCL: $(sbcl --version)" echo " - StumpWM: $(which stumpwm)" echo " - Emacs: $(emacs --version | head -n1)" echo " - Xpra: 
  # $(xpra --version | head -n1)"

