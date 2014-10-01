#!/bin/bash

: <<"USAGE"
This is a blog DEPLOYER one-liner:
- searches $KEY_DIR for valid github ssh key
- starts a Docker container which:
  - 'rake generate' : generates the blog via jekyll
  - 'rake deploy'   : deploys the result into the GH-PAGES branch

ENV VARIABLES:

  GITHUB_TOKEN     oauth2 token with repo scope. https://github.com/settings/tokens/new
  COMMIT_NAME      the username for the GH-PAGES commit (default: octopress)
  COMMIT_EMAIL     the email for the GH-PAGES commit (default: cat@octopress.org)
  KEY_DIR          where to look for valid Github ssh keys (dafault: ~/.ssh)

============================================
  curl -Ls j.mp/docker-blog|bash
============================================
USAGE

: ${GITHUB_TOKEN:? a valid GITHUB oauth2 token required with repo scope}

: ${COMMIT_NAME:=octopress}
: ${COMMIT_EMAIL:=cat@octopress.org}

EXTRA_ENV="-e COMMIT_NAME=$COMMIT_NAME -e COMMIT_EMAIL=$COMMIT_EMAIL"

if [ -n "$DEBUG" ];then
  echo debug on ...
  set -x
  EXTRA_ENV="$EXTRA_ENV -e DEBUG=1"
fi

: ${KEY_DIR:=~/.ssh}
: ${VERBOSE:=1}

is_valid_github_key() {
  ssh -a -T -o StrictHostKeyChecking=no -o IdentityFile=$1  -o IdentitiesOnly=yes git@github.com 2>&1 | grep "successfully authenticated" &>/dev/null
}

encode_file() {
  [[ "$(uname)" == "Darwin" ]] && WRAP_SWITCH='-b' || WRAP_SWITCH='-w'
  cat $1| base64 $WRAP_SWITCH 0
}

wrapper() {
  if [ -z "$GH_KEY" ]; then
    echo searching for github key in $KEY_DIR
    for key in $(find $KEY_DIR/ -type f -exec grep -l "BEGIN RSA PRIVATE KEY" {} \;) ; do
      if is_valid_github_key $key ; then
        [ -n "$VERBOSE" ] && echo [VALID] $key
        GH_KEY=$key
        break
      else
        [ -n "$VERBOSE" ] && echo [INVALID] $key
      fi
    done

    [ -z "$GH_KEY"  ] && echo [ERROR] no valid key in: KEY_DIR=$KEY_DIR && exit 1
  else
    is_valid_github_key $GH_KEY || echo $GH_KEY is invalid fo github && exit 1
  fi

  docker run \
    -e GIT_TAG=origin/source \
    -e GITHUB_KEY=$(encode_file $GH_KEY) \
    -e GITHUB_TOKEN=$GITHUB_TOKEN \
    sequenceiq/blog /github-release.sh
}

wrapper
