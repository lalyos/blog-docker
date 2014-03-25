This repo contains a Dockerfiel which helps you to deploy octopress based blogs
devops style. Guess what docker is involved ...

Instead of deploying the correct version of rbenv/ruby/gem/bundler/rake/python
just use the pre baken docker image:

```
docker run -e "KEY=$(cat ~/.ssh/id_rsa|base64)" sequenceiq/blog
```

Or if you want to see the progress
```
docker run -e "DEBUG=1" -e "KEY=$(cat ~/.ssh/id_rsa|base64)" -i sequenceiq/blog
```

## build the image

Just use the `build` command which uses the `-t` tag parameter and the last attribute
is the directory containing the `Dockerfile`

```
docker build -t sequenceiq/blog .
```
