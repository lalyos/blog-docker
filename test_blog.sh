#!/bin/bash

cd /tmp/blog
git fetch
git reset --hard origin/master
eval "$(rbenv init -)"
rake generate

rake deploy
