#!/bin/bash

if [ -n "$DEBUG" ];then
  echo debug on ...
  set -x
  EXTRA_ENV="-e DEBUG=1"
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

  DOCKER_CMD="docker run -e KEY=$(encode_file $GH_KEY) $EXTRA_ENV -i sequenceiq/blog"
  $DOCKER_CMD
}

wrapper
