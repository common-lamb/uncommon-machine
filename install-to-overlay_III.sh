#!/bin/bash

# Purpose: Install dotfiles and secrets management

set -e # Exit on error

# apptainer shell does not source .profile or .bashrc
source ~/.bashrc

DATE=$(date -I)

: << 'BLOCK'

# CERTIFICATES 
# ===========

guix install nss-certs 

export SSL_CERT_DIR="$HOME/.guix-profile/etc/ssl/certs"
export SSL_CERT_FILE="$HOME/.guix-profile/etc/ssl/certs/ca-certificates.crt"
export GIT_SSL_CAINFO="$SSL_CERT_FILE"
export CURL_CA_BUNDLE="$HOME/.guix-profile/etc/ssl/certs/ca-certificates.crt"

cat << 'EOF' >> ~/.bashrc

export SSL_CERT_DIR="$HOME/.guix-profile/etc/ssl/certs"
export SSL_CERT_FILE="$HOME/.guix-profile/etc/ssl/certs/ca-certificates.crt"
export GIT_SSL_CAINFO="$SSL_CERT_FILE"
export CURL_CA_BUNDLE="$HOME/.guix-profile/etc/ssl/certs/ca-certificates.crt"

EOF

echo "✓ Certificates"

# DOTFILES
# =======

guix install vim git stow curl

mkdir -p ~/.local/bin/ 
export PATH="$HOME/.local/bin/:$PATH"

cat << 'EOF' >> ~/.bashrc

export PATH="$HOME/.local/bin/:$PATH"

EOF

# stowman
curl -L https://raw.githubusercontent.com/ad-on-is/stowman/refs/heads/main/stowman.sh \
	> ~/.local/bin/stowman.sh
chmod +x ~/.local/bin/stowman.sh

# dotfiles
rm -rf ~/.uncommon-dotfiles
git clone https://github.com/uncommon-lamb/uncommon-dotfiles.git ~/.uncommon-dotfiles

echo "see TODO: maybe set dotfiles to ssh access"
cat << EOF >> ~/TODO

maybe set dotfiles to ssh access
if pushing changes
ensure ssh access is working

cd ~/.uncommon-dotfiles/git
vim config

git@github.com:common-lamb/uncommon-dotfiles.git
replaces
https://github.com/common-lamb/uncommon-dotfiles.git

EOF

echo "✓ Dotfiles"

# SECRETS
# =======

# age key pair
guix install age rsync

key_dir="${HOME}/.age-key"
export_dir="${HOME}/age-key-exported"

# new
if [ -f ${key_dir}/age-key_${DATE}.txt ] ; then
	echo "the key already exists"
else
	echo "creating a new age key"
	mkdir -p "$key_dir" 
	chmod 700 "$key_dir"
	age-keygen -o ${key_dir}/age-key_${DATE}.txt
	chmod 600 ${key_dir}/age-key_${DATE}.txt
fi

# export
echo "exporting the new age key"
mkdir -p "$export_dir"
chmod 700 "$export_dir"
echo "this password will protect the exported key"
age --encrypt --passphrase --armor \
	-o ${export_dir}/age-key_${DATE}.txt.age \
	${key_dir}/age-key_${DATE}.txt

# import
echo "importing the exported age key"
age --decrypt \
	-o ${key_dir}/age-key-imported.txt \
	${export_dir}/age-key_*.txt.age
chmod 600 ${key_dir}/age-key-imported.txt
creation_date=$( \
	cat ${key_dir}/age-key-imported.txt \
	| grep "created" \
	| sed s:"# created\: ":: \
	| sed s:T[0-9,:]*Z:: \
)
mv ${key_dir}/age-key-imported.txt ${key_dir}/age-key_${creation_date}.txt

echo "see TODO: rsync age key to this machine"
cat << EOF >> ~/TODO

rsync copy age key to this machine
execute on this machine to copy an age key 

rsync -avz <remote-user>@<remote-host>:~/${key_dir}/age-key_<DATE>.txt ~/${key_dir}/age-key_<DATE>.txt 
chmod 600 ~/${key_dir}/age-key_<DATE>.txt
# test: expect public key is output
age-keygen -y ~/${key_dir}/age-key_<DATE>.txt

EOF

echo "✓ age key pair"

# SSH key pair

guix install openssh

# new
mkdir -p ~/.ssh
chmod 700 ~/.ssh
if [ -f ~/.ssh/id_${DATE} ]; then
	echo "the key already exists"
else
	echo "this password will protect the ssh key"
	ssh-keygen -t ed25519 -C "${DATE}" -f ~/.ssh/id_${DATE} 
	chmod 600 ~/.ssh/id_${DATE}*
fi

eval "$(ssh-agent -s)"
echo "ssh key password required"
ssh-add ~/.ssh/id_${DATE}

cat << EOF >> ~/.bashrc

if [ -z "\$SSH_AUTH_SOCK" ]; then # is ssh-agent running?
    eval "\$(ssh-agent -s)" # set shell environment variables 
    echo "ssh key password required"
    ssh-add ~/.ssh/id_${DATE} 
fi

EOF

# export
cat << EOF >> ~/.ssh/config

Host github.com
    User git
    HostName github.com
    IdentityFile ~/.ssh/id_${DATE}

EOF

echo "see TODO: github sshkey activation"
cat << EOF >> ~/TODO

github sshkey activation
 To add the key to your GitHub account:
   - copy the public key at ~/.ssh/id_<DATE>.pub
   - ensure ~/.ssh/config IdentityFile matches the file chosen
   - Go to GitHub Settings > SSH and GPG keys
   - Click "New SSH key"
   - Paste your public key
   - Title with date from comment

test connection with:
  ssh -T git@github.com

public key:
$(cat ~/.ssh/id_${DATE}.pub)

EOF

# import
user=$(whoami)
hostname=$(hostname)
echo "see TODO: passwordless login with remote sshkey"
cat << EOF >> ~/TODO

passwordless login with remote sshkey
execute on another machine to send an ssh key to this machine

# send public key
ssh-copy-id -n -i ~/.ssh/id_<DATE>.pub ${user}@${hostname}
# if good remove -n dryrun

# test connection
ssh -v ${user}@${hostname}

EOF

echo "✓ SSH key pair"

BLOCK
# &&& multi line block end

# password store 
guix install pass-age nvi

# new
# this setup allows using the identity file password as the primary password to unlock the store
mkdir -p $HOME/.passage/store
touch $HOME/.passage/identities
chmod 600 $HOME/.passage/identities
KEY=$HOME/.age-key/age-key_${DATE}.txt
echo "this password will protect the passage store"
age --passphrase --armor $KEY > $HOME/.passage/identities
# just the public key
age-keygen -y $KEY > $HOME/.passage/store/.age-recipients

# create spoof keys
echo "creating example passage passwords"
echo "password" | passage insert -e tests/test
passage generate -n email/gmail 10
passage generate api/anthropic
passage generate api/openrouter
# &&& spoof all keys needed by dotfiles

echo "see TODO: correct example passage keys"
cat << 'EOF' >> ~/TODO

correct example passage keys
passage # list all 
passage edit each/password
passage insert new/password

EOF

# export 
cd ~/.passage/store
echo .age-recipients >> .gitignore
git config --global init.defaultBranch main
git init
git config user.name "user"
git config user.email "user@email.com"
git add .
git commit -m "first commit during setup: ${DATE}"

echo "see TODO: maybe push passage store to repository"
cat << 'EOF' >> ~/TODO

maybe push passage to repository
if it doesnt exist create a private repo
collect your username and reponame
ensure ssh access works

ssh -T git@github.com

cd ~/.passage/store
git remote add origin git@github.com:${username}/${privatereponame}
git push -u origin main

EOF

# import
echo "see TODO: maybe pull passage store from repository"
cat << 'EOF' >> ~/TODO

maybe pull passage store from repository
a private repo passage store exists
collect your username and reponame
ensure ssh access works

ssh -T git@github.com

cd ~/.passage/store
git remote add origin git@github.com:${username}/${privatereponame}
git fetch origin
git reset --hard origin main

EOF

echo "✓ Secrets"
