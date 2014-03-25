FROM tcnksm/rbenv
MAINTAINER SequenceIQ

RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN rbenv-install 1.9.3-p0

RUN git clone https://github.com/sequenceiq/blog.git /tmp/blog
RUN cd /tmp/blog && git checkout master

# sets the _deploy dir to connect to github via ssh
RUN git clone https://github.com/sequenceiq/blog.git /tmp/blog/_deploy
RUN cd /tmp/blog/_deploy && git remote set-url origin git@github.com:sequenceiq/blog.git

RUN apt-get install -y python
RUN cd /tmp/blog && eval "$(rbenv init -)" && rbenv global 1.9.3-p0 && gem install bundler && rbenv rehash && bundle install

ADD deploy_blog.sh /etc/deploy_blog.sh
RUN chmod +x /etc/deploy_blog.sh

CMD "/etc/deploy_blog.sh"
