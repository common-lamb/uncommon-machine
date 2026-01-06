#!/usr/bin/env bash

set -e # Exit on error

echo "in 09.sh"
echo "Purpose: network"

# container does not source .profile or .bashrc
source ~/.bashrc

# fresh dots
cd ~/.uncommon-dotfiles
git fetch
git pull

guix install xpra magic-wormhole cloudflare-cli n2n

echo "✓ network"
