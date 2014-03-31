This repo contains a Dockerfile which helps you to deploy octopress based blogs
devops style. Guess what docker is involved ...

Instead of deploying the correct version of rbenv/ruby/gem/bundler/rake/python
just use the pre baken docker image:

> if your github private ssh key is other than ~/.ssh/id_rsa just change the line

```
curl -Ls j.mp/docker-blog|bash
```

Or if you want to see the progress
```
(export DEBUG=1"; curl -Ls j.mp/docker-blog|bash)
```

## commit user

the script will generate the html pages, and push it to the `gh-pages` branch.
by default it uses the `octopress` name as commiter, if you want to customize it:

```
(export COMMIT_NAME=myself; export COMMIT_EMAIL=my@myslf.com; curl -Ls j.mp/docker-blog|bash)
```

## build the image

> You don't need to build the image it as its on [docker.io](https://index.docker.io/u/sequenceiq/)

But if you are hacking the Dockerfile, just use the `build` command which uses
the `-t` tag parameter for the image name. and the last attribute is the
directory containing the `Dockerfile`

```
docker build -t sequenceiq/blog .
```
