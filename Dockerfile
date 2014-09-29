FROM sequenceiq/blog:test

ONBUILD COPY . /tmp/blog
ONBUILD RUN rake generate

CMD ["server", "-dir", "public/blog/", "-h", "0.0.0.0"]
