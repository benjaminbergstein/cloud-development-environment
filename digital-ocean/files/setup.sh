#!/bin/bash

set -e


rm files.zip

# Set up GPG
export GPG_TTY=$(tty)
gpg --batch --import private.key

# Set up SSH key
gpg --decrypt id_rsa.gpg > id_rsa
eval `ssh-agent -s`
chmod 400 id_rsa
ssh-add id_rsa

# Clone repos
git clone git@github.com:benjaminbergstein/devbox.git
git clone git@github.com:benjaminbergstein/website.git

# This is so changes to vimrc are commit-able
rm .vimrc
ln -s $(pwd)/devbox/digitalocean/files/.vimrc .vimrc

# Install deps
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

apt-get update && apt-get install -y nodejs yarn

yarn global add ngrok http-server
