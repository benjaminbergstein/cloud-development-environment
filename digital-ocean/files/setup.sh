#!/bin/bash

set -e

rm files.zip

if [ -f private.key ]
then
  # Set up GPG
  export GPG_TTY=$(tty)
  gpg --batch --import private.key

  # Set up SSH key
  gpg --decrypt id_rsa.gpg > id_rsa
  eval `ssh-agent -s`
  chmod 400 id_rsa
fi

if [ -f id_rsa ]
then
  ssh-add id_rsa

  # Clone repos
  for repo in $(cat ./repos.txt)
  do
    git clone $repo
  done
fi

# This is so changes to vimrc are commit-able
rm .vimrc
ln -s /root/devbox/digital-ocean/files/.vimrc .vimrc

# Install deps
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

apt-get update && apt-get install -y nodejs yarn make

yarn global add ngrok http-server
