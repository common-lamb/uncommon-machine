#!/usr/bin/env bash

set -e # Exit on error

echo "in 05.sh"
echo "Purpose: workflows, disposable environments, data languages and containters,"

# container does not source .profile or .bashrc
source ~/.bashrc

guix install screen gwl btop
echo "✓ workflows"

guix install conda
conda init
echo "✓ conda"

guix install python r
echo "✓ data langs"

guix install passt runc podman singularity
echo "✓ containers"
