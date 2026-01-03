#!/usr/bin/env bash

set -e # Exit on error

echo "in 05.sh"
echo "Purpose: terminal and backgrounds"

# container does not source .profile or .bashrc
source ~/.bashrc

#install term, compositor, backgrounder
guix install kitty picom feh

# fresh dots
cd ~/.uncommon-dotfiles
git fetch
git pull

# dotfiles
cd ~/.uncommon-dotfiles
stow kitty
stow feh
stow background

echo "✓ terminal"
