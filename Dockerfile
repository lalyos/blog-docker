FROM ruby:1.9.3

RUN apt-get update \
      && apt-get install -y unzip

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

ADD server /usr/local/bin/server

RUN git clone https://github.com/sequenceiq/blog.git /tmp/blog \
    && cd /tmp/blog && git checkout master \
    && git clone https://github.com/sequenceiq/blog.git /tmp/blog/_deploy \
    && cd /tmp/blog/_deploy && git remote set-url origin git@github.com:sequenceiq/blog.git

WORKDIR /tmp/blog
RUN bundle install
ADD test_blog.sh /

EXPOSE 8080
CMD ["/test_blog.sh"]
