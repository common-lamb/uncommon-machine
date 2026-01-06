#!/usr/bin/env bash

set -e # Exit on error

echo "in 05.sh"
echo "Purpose: terminal"

# container does not source .profile or .bashrc
source ~/.bashrc

# fresh dots
cd ~/.uncommon-dotfiles
git fetch
git pull

#install term
guix install kitty mosh

# dotfiles
cd ~/.uncommon-dotfiles
stow kitty

echo "✓ terminal"
