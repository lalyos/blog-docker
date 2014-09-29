FROM ruby:1.9.3

RUN apt-get update \
      && apt-get install -y unzip

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

ADD server-linux /usr/local/bin/

RUN cd /tmp \
      && curl -LO https://github.com/sequenceiq/blog/archive/master.zip \
      && unzip master.zip

WORKDIR /tmp/blog-master

RUN bundle install
#RUN rake generate
