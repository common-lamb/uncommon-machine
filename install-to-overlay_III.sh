#!/bin/bash

# Purpose: Install dotfiles and secrets management

set -e # Exit on error

# apptainer shell does not source .profile or .bashrc
source ~/.bashrc

# CERTIFICATES 
# ===========
guix install nss-certs 
export SSL_CERT_DIR="$HOME/.guix-profile/etc/ssl/certs"
export SSL_CERT_FILE="$HOME/.guix-profile/etc/ssl/certs/ca-certificates.crt"
export GIT_SSL_CAINFO="$SSL_CERT_FILE"
export CURL_CA_BUNDLE="$HOME/.guix-profile/etc/ssl/certs/ca-certificates.crt"

echo << EOF >> ~/.bashrc
export SSL_CERT_DIR="$HOME/.guix-profile/etc/ssl/certs"
export SSL_CERT_FILE="$HOME/.guix-profile/etc/ssl/certs/ca-certificates.crt"
export GIT_SSL_CAINFO="$SSL_CERT_FILE"
export CURL_CA_BUNDLE="$HOME/.guix-profile/etc/ssl/certs/ca-certificates.crt"
EOF

echo "✓ Certificates"

# DOTFILES
# =======
guix install vim git stow openssh curl

# stowman
mkdir -p ~/.local/bin/ 
curl -L https://raw.githubusercontent.com/ad-on-is/stowman/refs/heads/main/stowman.sh \
	> ~/.local/bin/stowman
chmod +x ~/.local/bin/stowman

rm -rf ~/.uncommon-dotfiles
git clone https://github.com/uncommon-lamb/uncommon-dotfiles.git ~/.uncommon-dotfiles

echo "✓ Dotfiles"

# SECRETS
# =======

echo "✓ Secrets"
