Before you push your blog to the **master** branch, it should be tested.
Testing means:

- generating the static files with jekyll
- serving static pages with some *webserver*

It's definitely not enough if it looks good on github, or in your markdown editor.

## Testing the blog

This image aims to test the blog before publication. The trick is: first push
your changes to the **test** brach.

Then you can start a local blog server by:
```
docker run -it --rm -p 8080:8080 sequenceiq/blog:test
```

It will:

- fetch the latest changes from git
- git hard reset to **origin/test**
- rake generate
- serve the **public/blog** directory on port 8080

Once You see something like this:
```
Successfully generated site: source -> public/blog
2014/09/29 11:07:32 Serving files from public/blog/ at 0.0.0.0:8080
```
You can start browsing the test blog at: http://192.168.59.103:8080/

## Terminate the server

simly press `CTRL-C`, it wil stop nd remove the docker container.
