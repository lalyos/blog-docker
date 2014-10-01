
To deploy the blog-test's **source** [branch](https://github.com/sequenceiq/blog-test)
to the [qa](http://qa.blog.sequenceiq.com/) site, just use this oneliner (tm):

```
curl -Ls j.mp/docker-blog | bash
```

## Manual deployment

If you want to start manually the Docker container, here comes the detailed
description. The deployer container started as:

```
docker run \
  -e GIT_TAG=origin/source \
  -e GITHUB_KEY=$GITHUB_KEY \
  -e GITHUB_TOKEN=$GITHUB_TOKEN \
  -e TRACE=1 \
  sequenceiq/blog /github-release.sh
```

if it succeeds the new [qa blog](http://qa.blog.sequenceiq.com/) is ready

Required ENV variables:

- `GITHUB_KEY` : base64 encoded ssh key for github push
- `GITHUB_TOKEN` : oauth2 token with **repo** scope. You can generate a new at:
   Github/Settings/Applications/[Generate new Token](https://github.com/settings/tokens/new)

## GITHUB_KEY

To set the `GITHUB_KEY` env variable to `~/.ssh/id_rsa` run the OS specific script:

### OSX

```
GITHUB_KEY=$(cat ~/.ssh/id_rsa | base64 -b 0)
```

### Linux

```
GITHUB_KEY=$(cat ~/.ssh/id_rsa | base64 -w 0)
```
