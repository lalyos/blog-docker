#!/bin/bash

cd /tmp/blog
git fetch
git reset --hard origin/test
rake generate

server -dir public/blog/ -h 0.0.0.0
