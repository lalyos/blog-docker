#!/bin/bash

: ${GITHUB_KEY:? base64 encoded ssh key for github push}

[ -n "$DEBUG" ] && echo debug on ... && set -x

: ${COMMIT_NAME:=octopress}
: ${COMMIT_EMAIL:=cat@octopress.org}

mkdir -p /root/.ssh
chmod 700 /root/.ssh

# switch off debug to hide private key
set +x
echo ${GITHUB_KEY}|base64 -d> /root/.ssh/id_rsa
[ -n "$DEBUG" ] && echo debug on ... && set -x

chmod 600 /root/.ssh/id_rsa

# saves githubs host to known_hosts
ssh -T -o StrictHostKeyChecking=no  git@github.com

git config --global user.name "$COMMIT_NAME"
git config --global user.email "$COMMIT_EMAIL"

cd /tmp/blog
git fetch
git reset --hard origin/master
eval "$(rbenv init -)"
rake generate

rake deploy
