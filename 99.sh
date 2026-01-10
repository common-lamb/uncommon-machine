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

# to: networking
guix install iputils wget

# to: conda
# install miniforge
guix remove conda

mkdir ~/temp-conda && cd ~/temp-conda
wget -O Miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3.sh -b -p "${HOME}/conda"
cd ~ && rm -r ~/temp-conda

source "${HOME}/conda/etc/profile.d/conda.sh"
source "${HOME}/conda/etc/profile.d/mamba.sh"
conda init

# to: spacemacs
# emacs compiled for remote
guix remove emacs
guix install emacs-lucid

# solves special characters in spacemacs
cat << 'EOF' >> ~/.bashrc

# set locale and lang
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export LANGUAGE=C.UTF-8

EOF

# lsp layer uses npm
apt-get install -y npm

#stop and restart to initialize
emacsclient -e '(kill-emacs)'
emacs --daemon


# To: programming languages
guix install r


# to: git
rm ~/.gitconfig
cd ~/.uncommon-dotfiles
stow git

# to: lisp II
guix install fd libvterm # &&& maybe also libvterm-dev for terminal

# to: lisp II
# stumpwm contrib and modules
mkdir -p ~/.stumpwm.d/contrib
mkdir -p ~/.stumpwm.d/modules
git clone https://github.com/stumpwm/stumpwm-contrib ~/.stumpwm.d/contrib
# &&& symlink nice things from contrib to modules
# cd ~/.stumpwm.d/contrib ln -s &&& ../modules/&&&






# spacemacs buffer.el corrupting

# &&& rundle ridge desktop

# Writing
#Citation
#Latex, guix install texlive
#Mermaid via snap
# install language tool

#user add
#user, password
#copy root home

# decoupling:  compute, setup, configuration, secrets, data
