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

guix install screen gwl btop slurm
echo "✓ workflows"

guix install duckdb sqlite
echo "✓ databases"

guix install conda
# &&& conda init breaks 07.sh at source .bashrc
#conda init
echo "✓ conda"

guix install python r
echo "✓ data langs"

guix install passt runc podman
# &&& install apptainer
echo "✓ containers"
