#!/usr/bin/env bash

set -e # Exit on error

echo "in 99.sh"
echo "Purpose: patches"

# container does not source .profile or .bashrc
source ~/.bashrc

# fresh dots
cd ~/.uncommon-dotfiles
git fetch
git pull

# ======================================
# 00 base os pull, locale, os update
# ======================================
# ======================================
# 01 guix I test daemon
# ======================================
# ======================================
# 02 guix II, daemon start, dependencies
# ======================================
# ======================================
# 03 security encryption dotfiles secrets
# ======================================
# &&& spoof all keys needed by dotfiles
# ======================================
# 04 emacs, emacs supporting packages, spacemacs
# ======================================

# &&& spacemacs buffer.el corrupting
# to change emacs in patches stop and restart to rerun initialization
# emacsclient -e '(kill-emacs)'
# emacs --daemon

# ======================================
# 05 terminal
# ======================================
# ======================================
# 06 workflows, disposable environments, data languages and containers,
# ======================================

# &&& install apptainer

# ======================================
# 07 lisp I, SBCL, quicklisp, ultralisp, ocicl, shl
# ======================================

# &&& lower ultralisp priority
# (ql-dist:all-dists)
# (ql-dist:preference (first (ql-dist:all-dists))) ;the universal time of setting
# (ql-dist:preference (second (ql-dist:all-dists)))

# (setf (ql-dist:preference (first (ql-dist:all-dists)))
#       (get-universal-time))

# (loop with dists = (sort (copy-list (ql-dist:enabled-dists))
#                          #'>
#                          :key #'ql-dist:preference)
#       for dist in dists
#       do (format t "* ~A (~A)~%"
#                  (ql-dist:name dist)
#                  (ql-dist:version dist)))

# &&& Ocicl
# &&& Ocicl setup

# ======================================
# 08 lisp II Lish, lem, nyxt, stumpw
# ======================================

git clone https://github.com/fukamachi/.lem ~/.lem

mkdir -p ~/common-lisp && cd ~/common-lisp
git clone https://github.com/fukamachi/lem-vi-sexp.git
# &&& pick up and push fukamachi's config
# &&& remove the clone line activate the stow line
# cd ~/.uncommon-dotfiles
# stow lem

# &&& nyxt
# timed out
# guix install nyxt emacs-nyxt
# cd ~/.uncommon-dotfiles
# stow nyxt


# &&& stump
# symlink nice things from contrib to modules
# cd ~/.stumpwm.d/contrib ln -s &&& ../modules/&&&

# ======================================
# 09 network
# ======================================

# &&& Email
# https://jf-parent.github.io/blog/2020/01/01/email-from-spacemacs-my-mu4e-org-msg-offlineimap-setup/

# &&& ipfs private network
# &&& tailscale vpn

# ======================================
# 10 data storage redundancy and access
# ======================================

# # setup dropbox
# rclone config #make new @ db
# rclone lsd db:
# mkdir -p ~/db/1
# # start
# rclone mount db:1 ~/db/1 --vfs-cache-mode full &
# # stop
# cd ~ && fusermount -u ~/db/1

# ======================================
# 11 graphics and styling
# ======================================

# &&& set XTERM etc
# &&& rundle ridge desktop
# &&& lunaria light palette

# ======================================
# 12 agents and models
# ======================================








# ======================================
# &&& Writing
# ======================================
# &&& Citation
# &&& Latex, guix install texlive
# &&& Mermaid via snap
# &&& install language tool

#user add
#user, password
#copy root home


# decoupling:  compute, setup, configuration, secrets, data
