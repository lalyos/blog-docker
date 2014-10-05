Before you push your blog to the **source** branch, it should be tested.
Testing means:

- generating the static files with jekyll
- serving static pages with some *webserver*

It's definitely not enough if it looks good on github, or in your markdown editor.

## Testing the blog

To locally test a new blog entry, follow these steps:

- Checkout the [sequenceiq/blog-test](https://github.com/sequenceiq/blog-test) github repo.
- Create a new post like `source/_posts/2014-08-31-my-new-blog.markdown`
- Create and run a blog-test container:

```
./blog-test.sh

Options:
  -d --dirty    don't stash uncommitted changed
```

It will:

- stash away uncommitted changes (unless -d is used)
- `COPY` the workdir to a new *blog-test* Docker image, at `/tmp/blog`
- `RUN rake generate` inside the container
- start the new Docker image, which will serve the **public/blog** on http
- stash back
- Automatically open a browser pointing to: http://192.168.59.103:8080/


## Changing local port

In case your port `8080` is already occupied, you can change it:
```
export BLOG_PORT=9876
./blog-test.sh
```

## Terminate the server

The blog server is started as a backround container. To clean up:

```
docker rm -f blog-test && docker rmi blog-test-image
```
