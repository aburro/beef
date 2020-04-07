FROM ruby:2.6.3-alpine AS builder
LABEL maintainer="Beef Project: github.com/beefproject/beef"

# requires --gemfile=/beef/Gemfile $BUNDLER_ARGS && on line 11 below
ARG BUNDLER_ARGS="--jobs=4" 

RUN echo "gem: --no-ri --no-rdoc" > /etc/gemrc

COPY . /beef

RUN apk add --no-cache git curl libcurl curl-dev ruby-dev libffi-dev make g++ gcc musl-dev zlib-dev sqlite-dev && \
  bundle install --system --clean --no-cache --gemfile=/beef/Gemfile $BUNDLER_ARGS && \
  # Temp fix for https://github.com/bundler/bundler/issues/6680
  rm -rf /usr/local/bundle/cache

WORKDIR /beef

# So we don't need to run as root
RUN chmod -R a+r /usr/local/bundle

FROM ruby:2.6.3-alpine
LABEL maintainer="Beef Project: github.com/beefproject/beef"

RUN adduser -h /beef -g beef -D beef

COPY . /beef

COPY --from=builder /usr/local/bundle /usr/local/bundle

RUN chown -R beef:beef /beef

RUN apk add --no-cache curl git build-base openssl readline-dev zlib zlib-dev libressl-dev yaml-dev sqlite-dev sqlite libxml2-dev libxslt-dev autoconf libc6-compat ncurses5 automake libtool bison nodejs

WORKDIR /beef

USER beef

EXPOSE 3000 6789 61985 61986

ENTRYPOINT ["/beef/beef"]