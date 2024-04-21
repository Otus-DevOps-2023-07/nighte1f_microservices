FROM alpine:3.16

RUN apk update --no-cache \
    && apk add --no-cache ruby-full ruby-dev build-base \
    && gem install bundler -v 1.17.2 \
    && rm -rf /var/cache/apk/*

ENV APP_HOME /app
RUN mkdir $APP_HOME

WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/
RUN bundle update --bundler

ADD . $APP_HOME

ENV POST_SERVICE_HOST post
ENV POST_SERVICE_PORT 5000
ENV COMMENT_SERVICE_HOST comment
ENV COMMENT_SERVICE_PORT 9292

CMD ["puma"]
