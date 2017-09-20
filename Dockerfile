# Basic testing environment with Ruby and Bundler
#
# To build the virtual machine and connect to it, run:
#  docker build -t meetup-cli .
#  docker run -itP meetup-cli
#
# Run the app with:
#  bin/meetup-cli

FROM alpine:3.6
MAINTAINER Ildar Sagdejev <specious@gmail.com>

ENV BUILD_PACKAGES bash ruby-dev build-base
ENV RUBY_PACKAGES ruby ruby-bundler

RUN apk update
RUN apk upgrade
RUN apk --no-cache add $BUILD_PACKAGES $RUBY_PACKAGES

RUN mkdir /usr/app
WORKDIR /usr/app

COPY . /usr/app

RUN bundle install