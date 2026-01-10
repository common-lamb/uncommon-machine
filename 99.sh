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


# solves special characters in spacemacs
cat << 'EOF' >> ~/.bashrc

# set locale and lang
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export LANGUAGE=C.UTF-8

EOF

# untested install miniforge
guix install wget

mkdir ~/temp-conda && cd ~/temp-conda
wget -O Miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3.sh -b -p "${HOME}/conda"
cd ~ && rm -r ~/temp-conda

source "${HOME}/conda/etc/profile.d/conda.sh"
source "${HOME}/conda/etc/profile.d/mamba.sh"

conda activate

# stumpwm contrib and modules
mkdir -p ~/.stumpwm.d/contrib
mkdir -p ~/.stumpwm.d/modules
git clone https://github.com/stumpwm/stumpwm-contrib ~/.stumpwm.d/contrib
cd ~/.stumpwm.d/contrib ln -s &&& ../modules/&&&

# emacs compiled for remote
guix install emacs-lucid

# install R
# activate ESS

#rundle ridge desktop

# Writing
  #Citation
  #Latex, guix install texlive
  #Mermaid via snap

#user add
#user, password
#copy root home

# lem needs, check if already installed
# libvterm-dev
# fd or fd-find

