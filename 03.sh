#!/usr/bin/env bash

set -e # Exit on error

echo "in 03.sh"
echo "Purpose: dotfiles encryption and secrets management"

# container does not source .profile or .bashrc
source ~/.bashrc

DATE=$(date -I)

: << 'DONE'
DONE

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
git clone https://github.com/uncommon-lamb/uncommon-dotfiles.git ~/.uncommon-dotfiles

echo "see TODO: maybe set dotfiles to ssh access"
cat << EOF >> ~/TODO

* TODO maybe set dotfiles to ssh access

# if pushing changes
cd ~/.uncommon-dotfiles
git remote set-url origin git@github.com:common-lamb/uncommon-dotfiles.git

# ensure ssh key is correct or added

# ensure ssh access is working
ssh -T git@github.com

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
echo "see TODO: maybe export the new age key"
cat << EOF >> ~/TODO

* TODO maybe export the new age key

mkdir -p "$export_dir"
chmod 700 "$export_dir"
echo "this password will encrypt the exported key"
age --encrypt --passphrase --armor \
	  -o ${export_dir}/age-key_${DATE}.txt.age \
	  ${key_dir}/age-key_${DATE}.txt

EOF

# import
echo "see TODO: rsync an age key to this machine"
cat << EOF >> ~/TODO

* TODO rsync an age key to this machine

# execute on this machine to copy an age key
rsync -avz <remote-user>@<remote-host>:~/${key_dir}/age-key_<DATE>.txt \
           ~/${key_dir}/age-key_<DATE>.txt
chmod 600 ~/${key_dir}/age-key_<DATE>.txt

# test: expect public key is output
age-keygen -y ~/${key_dir}/age-key_<DATE>.txt

EOF

echo "see TODO: maybe import an encrypted age key"
cat << EOF >> ~/TODO

* TODO maybe import an encrypted age key

#decrypt
touch ${key_dir}/age-key-imported.txt
chmod 600 ${key_dir}/age-key-imported.txt
echo "age key decryption password required"
age --decrypt \
	  -o ${key_dir}/age-key-imported.txt \
	  ${export_dir}/age-key_<DATE>.txt.age

# extract date and rename
creation_date=$( \
	               cat ${key_dir}/age-key-imported.txt \
	                   | grep "created" \
	                   | sed s:"# created\: ":: \
	                   | sed s:T[0-9,:]*Z:: \
             )
mv ${key_dir}/age-key-imported.txt ${key_dir}/age-key_${creation_date}.txt

EOF

echo "✓ age key pair"

# SSH key pair

guix install openssh

# new
echo "see TODO: create an ssh key"
cat << 'EOF' >> ~/TODO

* TODO create an ssh key

mkdir -p ~/.ssh
chmod 700 ~/.ssh
DATE=$(date -I)
if [ -f ~/.ssh/id_${DATE} ]; then
	echo "the key already exists"
else
	echo "this password will protect the ssh key"
	ssh-keygen -t ed25519 -C "${DATE}" -f ~/.ssh/id_${DATE}
	chmod 600 ~/.ssh/id_${DATE}*
fi

EOF

# export
mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/config
chmod 600 ~/.ssh/config

cat << EOF >> ~/.ssh/config

Host github.com
    User git
    HostName github.com
    IdentityFile ~/.ssh/id_<DATE>

EOF

cat << 'EOF' >> ~/.bashrc

# &&& edit DATE before use
load_ssh_key() {
    if [ -z "$SSH_AUTH_SOCK" ]; then # is ssh-agent running?
        eval "$(ssh-agent -s)" # set shell environment variables
        echo "ssh key password required"
        ssh-add ~/.ssh/id_DATE
    fi
}

EOF

echo "see TODO: edit ssh key dates in configs"
cat << 'EOF' >> ~/TODO

* TODO edit ssh key dates in configs

# extract date
&&& extract date from ~/.ssh/id_${DATE}

# in ~/.bashrc at load_ssh_key function
&&& sed  replace ssh-add ~/.ssh/id_DATE

# in ~/.ssh/config
&&& sed replace IdentityFile ~/.ssh/id_<DATE>

EOF

echo "see TODO: github sshkey activation"
cat << EOF >> ~/TODO

* TODO github sshkey activation
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
cat ~/.ssh/id_<DATE>.pub

EOF

# import
echo "see TODO: passwordless login with remote sshkey"
cat << EOF >> ~/TODO

* TODO passwordless login with remote sshkey

# execute on this machine
user=$(whoami)
hostname=$(hostname)

# execute on another machine to send an ssh key to this machine
# send public key
ssh-copy-id -n -i ~/.ssh/id_<DATE>.pub <USER>@<HOSTNAME>
# if good remove -n dryrun

# test connection
ssh -v <USER>@<HOSTNAME>

EOF

echo "✓ SSH key pair"

# password store
guix install pass-age nvi

# new
# this setup allows using the identity file password as the primary password to unlock the store
mkdir -p $HOME/.passage/store
touch $HOME/.passage/identities
chmod 600 $HOME/.passage/identities

KEY=$HOME/.age-key/age-key_${DATE}.txt
#echo "this password will protect the passage store"
#age --passphrase --armor $KEY > $HOME/.passage/identities
# no password
cat ${KEY} > $HOME/.passage/identities
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

* TODO correct example passage keys
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

* TODO maybe push passage to repository

# if it doesnt exist, create a private repo
# collect username and privatereponame

# ensure ssh access works
ssh -T git@github.com

# push
cd ~/.passage/store
git remote add origin git@github.com:<USERNAME>/<PRIVATEREPONAME>
git push -u origin main

EOF

# import
echo "see TODO: maybe pull passage store from repository"
cat << 'EOF' >> ~/TODO

* TODO maybe pull passage store from repository

# a private repo passage store exists
# collect username and privatereponame

# ensure ssh access works
ssh -T git@github.com

# pull
cd ~/.passage/store
git remote add origin git@github.com:<USERNAME>/<PRIVATEREPONAME>
git fetch origin
git reset --hard origin main

EOF

echo "✓ Secrets"
