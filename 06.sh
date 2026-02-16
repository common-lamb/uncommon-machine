#!/usr/bin/env bash

set -e # Exit on error

echo "in 06.sh"
echo "Purpose: workflows, disposable environments, data languages and containers,"

# container does not source .profile or .bashrc
source ~/.bashrc

# fresh dots
cd ~/.uncommon-dotfiles
git fetch
git pull

rm -f ~/.gitconfig
cd ~/.uncommon-dotfiles
stow git
echo "✓ git"

guix install screen gwl btop slurm
echo "✓ workflows"

guix install duckdb sqlite
echo "✓ databases"

# install miniforge
mkdir ~/temp-conda && cd ~/temp-conda
wget -O Miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3.sh -b -p "${HOME}/conda"
cd ~ && rm -r ~/temp-conda

source "${HOME}/conda/etc/profile.d/conda.sh"
source "${HOME}/conda/etc/profile.d/mamba.sh"
conda init
echo "✓ conda"

guix install python r
echo "✓ data langs"

guix install passt runc podman
echo "✓ containers"
