#!/bin/bash

: <<USAGE
==========================================================
this script intended to try the 'test' branch of the blog
its not used right now, just kept as reference
==========================================================
USAGE

cd /tmp/blog
git fetch
git reset --hard origin/test
rake generate

server -dir public/blog/ -h 0.0.0.0
