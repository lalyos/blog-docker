#!/bin/bash
set -e

: ${GITHUB_KEY:? a valid base64 encoded github ssh key required }
: ${GITHUB_TOKEN:? a valid GITHUB oauth2 token required with repo scope}

: ${COMMIT_NAME:=octopress}
: ${COMMIT_EMAIL:=cat@octopress.org}

: ${DEBUG:=1}
: ${TRACE:=0}

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

githubcurl() {
  path=$1;
  shift;
  curl https://api.github.com/$path -H "Authorization: token ${GITHUB_TOKEN}" "$@"
}

github_calc_new_release() {
  lastRelease=$(githubcurl repos/${SOURCE_REPO}/releases -s|jq .[0].tag_name -r)
  debug last release of ${SOURCE_REPO} : $lastRelease
  lastDigit=${lastRelease##*.}
  releasePrefix=${lastRelease%.*}

  NEW_RELEASE="${releasePrefix}.$(($lastDigit + 1))"
  debug new release will be: $NEW_RELEASE
}

git_reset_if_needed() {
  if [ -n "$GIT_TAG" ]; then
    debug "git hard reset to $GIT_TAG"
    git fetch
    git stash save -u "clean uncommited changes"
    git reset --hard ${GIT_TAG}
  fi
}

create_static_site_tar() {
  git_reset_if_needed
  debug generating static site as a tar file ...
  github_setup
  cd $BLOG_DIR
  rake generate
  tar cf /tmp/gh-pages.tar -C ./public/blog --exclude=CNAME .
}

push_tar_to_gh_branch() {
  git clone git@github.com:${SOURCE_REPO}.git /tmp/gh-pages
  cd /tmp/gh-pages

  git checkout gh-pages
  rm -rf blog
  tar xf /tmp/gh-pages.tar

  github_calc_new_release
  echo $NEW_RELEASE > version.html

  debug adding new files and modifications ...
  git add .

  # stage all file deletion (like: flat for sale)
  git status -s|sed -n "s/^[ ]*D *//p"|xargs --no-run-if-empty git rm

  git commit -m "Site regenerated version: $NEW_RELEASE"
  git tag $NEW_RELEASE
  git push origin gh-pages --tags
  debug tag: $NEW_RELEASE pushed to github
}

github_release() {
  debug creting new release: $NEW_RELEASE on github
  debug give 5 sec time to github API to realise the new tag ...
  sleep 5
githubcurl repos/${SOURCE_REPO}/releases -X POST -d @- <<EOF
{
  "tag_name": "$NEW_RELEASE",
  "target_commitish": "gh-pages"
}
EOF
}


create_static_site_tar
push_tar_to_gh_branch
github_release
