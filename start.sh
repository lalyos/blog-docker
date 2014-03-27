#!/bin/bash

[ -n "$DEBUG" ] && echo debug on ... && set -x && EXTRA_ENV=' -e "DEBUG=1" '
: ${KEY_DIR:=~/.ssh}

is_valid_github_key() {
  ssh -a -T -o StrictHostKeyChecking=no -o IdentityFile=$1  -o IdentitiesOnly=yes git@github.com 2>&1 | grep "successfully authenticated" &>/dev/null
}

encode_file() {
  [[ "$(uname)" == "Darwin" ]] && WRAP_SWITCH='-b' || WRAP_SWITCH='-w'
  cat $1| base64 $WRAP_SWITCH 0
}

if [ -z "$GH_KEY" ]; then
  echo searching for github key in $KEY_DIR
  for key in $(find $KEY_DIR/ -type f -exec grep -l "BEGIN RSA PRIVATE KEY" {} \;) ; do
    # checks if the key authenticates to github

    if is_valid_github_key $key; then
      GH_KEY=$key
      break
    fi
  done
else
  if is_valid_github_key $GH_KEY; then
    echo valid GH_KEY=$GH_KEY
  else
    cat<<EOF

  [ERROR] $GH_KEY isn't a valid github key
    please check it with:
    ssh -a -T -o StrictHostKeyChecking=no -o IdentityFile=$1  -o IdentitiesOnly=yes git@github.com
EOF
    exit 1
  fi

fi

: ${GH_KEY?'missing github private key please "export GH_KEY=<key_path>"'}


DOCKER_CMD="docker run -e KEY=$(encode_file $GH_KEY) $EXTRA_ENV -i sequenceiq/blog"
$DOCKER_CMD
