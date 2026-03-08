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
# 00 base os pull, os update
# ======================================
# ======================================
# 01 guix I test daemon, pull
# ======================================
# ======================================
# 02 guix II, start daemon
# ======================================

cat << 'EOF' >> ~/.config/guix/channels.scm:

(cons* (channel
        (name 'guix)
        (url "https://git.savannah.gnu.org/git/guix.git")
        (introduction
          (make-channel-introduction
            "9edb3f66fd807b096b48283debdcddccfea34bad"
            (openpgp-fingerprint
              "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA"))))

       (channel
        (name 'nonguix)
        (url "https://gitlab.com/nonguix/nonguix")
        (introduction
          (make-channel-introduction
            "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
            (openpgp-fingerprint
              "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))

(channel
 (name 'guix-science)
          (url "https://codeberg.org/guix-science/guix-science.git")
          (branch "master")
          (introduction
            (make-channel-introduction
              "b1fe5aaff3ab48e798a4cce02f0212bc91f423dc"
              (openpgp-fingerprint
                "CA4F 8CF4 37D7 478F DA05  5FD4 4213 7701 1A37 8446"))))

      %default-channels)

EOF
# ======================================
# 03 security encryption dotfiles secrets
# ======================================

# &&& spoof all keys needed by dotfiles

# ======================================
# 04 emacs, locale, emacs supporting packages, spacemacs
# ======================================

# &&& spacemacs buffer.el corrupting
# to change emacs in patches stop and restart to rerun initialization
# emacsclient -e '(kill-emacs)'
# yes | emacs --daemon

# ======================================
# 05 terminal
# ======================================
# ======================================
# 06 git, workflows, disposable environments, data languages and containers,
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

# ======================================
# 08 lisp II Lish, lem, nyxt, stumpw
# ======================================

# guix remove lem

# mkdir -p ~/temp && cd ~/temp
# # download nightly build
# curl -o lem.appimage -L https://github.com/lem-project/lem/releases/download/nightly-latest/Lem-x86_64.AppImage
# # unpack
# chmod +x lem.appimage
# ./lem.appimage --appimage-extract
# mv squashfs-root lem-squashfs
# # place
# mkdir -p ~/.local/share/lem/
# mv lem-squashfs ~/.local/share/lem/
# # symlink
# cd ~/.local/share/lem/lem-squashfs/
# ln -s $(realpath AppRun) ~/.local/bin/lem
# # cleanup
# cd ~ && rm -r ~/temp
# #  test
# lem --help

# # &&& add fukamachi's config to dotfiles
# # git clone https://github.com/fukamachi/.lem ~/.lem
# mkdir -p ~/common-lisp && cd ~/common-lisp
# git clone https://github.com/fukamachi/lem-vi-sexp.git
cd ~/.uncommon-dotfiles
stow lem

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

# &&& tailscale headscale vpn
# &&& ipfs private network

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

# Load dependencies from ocicl
# sbcl --eval '(asdf:load-system :cl-mcp-server)' --quit # what version is this &&&

# &&& todo NVIDIA in conda

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

# guix install sudo

# username=user
# password=password

# adduser --no-create-home --gecos "" --disabled-password $username
# echo "${username}:${password}" | chpasswd
# usermod -aG sudo "${username}"

# touch /etc/sudoers
# chmod 0440 /etc/sudoers

# cat > /etc/sudoers << EOF

# # allow root to act as sudo NO pw prompt
# root    ALL=(ALL) NOPASSWD:ALL

# # Allow members of group sudo to execute any command
# %sudo   ALL=(ALL:ALL) ALL

# # allow user to act as sudo after pw prompt
# # user    ALL=(ALL) ALL

# EOF

# echo "check"
# visudo --check

# sudo --list


# decoupling:  compute, setup, configuration, secrets, data
