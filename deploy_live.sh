#!/bin/bash

: ${DEBUG:=1}
: ${TRACE:=0}
: ${RELEASE:=latest}
: ${SOURCE_REPO:=sequenceiq/blog-test}
: ${TARGET_REPO:=sequenceiq/blog}

: ${COMMIT_NAME:=octopress}
: ${COMMIT_EMAIL:=cat@octopress.org}

: ${TEMP_REL_DIR:=/tmp/release}

[ $TRACE -gt 0 ] && set -x

debug() {
  [ $DEBUG -gt 0 ] && echo "[DEBUG] $*" 1>&2
}

github_setup() {
  debug setting up github keys/config ...

  mkdir -p /root/.ssh
  chmod 700 /root/.ssh
  echo $GITHUB_KEY|base64 -d> /root/.ssh/id_rsa
  chmod 600 /root/.ssh/id_rsa
  ssh -T -o StrictHostKeyChecking=no  git@github.com || true

  git config --global user.name "$COMMIT_NAME"
  git config --global user.email "$COMMIT_EMAIL"
}

get_latest_release_number() {
  curl -s  https://api.github.com/repos/${SOURCE_REPO}/releases?per_page=1|jq .[0].tag_name -r
}

download_release() {
  if [[ "$RELEASE" == "latest" ]]; then
    RELEASE=$(get_latest_release_number)
  fi
  debug downloading tar RELEASE=$RELEASE

  curl -L https://api.github.com/repos/${SOURCE_REPO}/tarball/${RELEASE} \
    | tar xz --strip=1
}

push_tar_to_gh_branch() {
  git clone git@github.com:${TARGET_REPO}.git ${TEMP_REL_DIR}
  cd ${TEMP_REL_DIR}

  git checkout gh-pages
  rm -rf *
  download_release

  debug restore CNAME
  git reset HEAD CNAME
  git checkout -- CNAME
  
  debug adding new files and modifications ...
  git add .

  # stage all file deletion (like: flat for sale)
  git status -s|sed -n "s/^[ ]*D *//p"|xargs --no-run-if-empty git rm

  git commit -m "Deploy release: $RELEASE"
  git tag $RELEASE
  git push origin gh-pages --tags
  debug tag: $RELEASE pushed to github
}

github_setup
push_tar_to_gh_branch
