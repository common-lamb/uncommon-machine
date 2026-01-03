
#!/usr/bin/env bash

set -e # Exit on error

echo "in 05.sh"
echo "Purpose: terminal"

guix install kitty picom feh

cd ~/.uncommon-dotfiles
stow kitty
stow feh
stow background
