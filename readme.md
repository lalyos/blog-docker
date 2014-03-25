This repo contains a Dockerfile which helps you to deploy octopress based blogs
devops style. Guess what docker is involved ...

Instead of deploying the correct version of rbenv/ruby/gem/bundler/rake/python
just use the pre baken docker image:

> if your github private ssh key is other than ~/.ssh/id_rsa just change the line

```
docker run -e "KEY=$(cat ~/.ssh/id_rsa|base64)" sequenceiq/blog
```

Or if you want to see the progress
```
docker run -e "DEBUG=1" -e "KEY=$(cat ~/.ssh/id_rsa|base64)" -i sequenceiq/blog
```

## commit user

the script will generate the html pages, and push it to the `gh-pages` branch.
by default it uses the `octopress` name as commiter, if you want to customize it:

```
docker run -e 'COMMIT_NAME=myself'y -e 'COMMIT_EMAIL=my@myslf.com' -e "KEY=$(cat ~/.ssh/id_rsa|base64)" sequenceiq/blog
```

## build the image

> You don't need to build the image it as its on [docker.io](https://index.docker.io/u/sequenceiq/)

But if you are hacking the Dockerfile, just use the `build` command which uses
the `-t` tag parameter for the image name. and the last attribute is the
directory containing the `Dockerfile`

```
docker build -t sequenceiq/blog .
```
