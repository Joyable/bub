FROM ruby:2.5.1

# Pry's paging gets weird without less installed
RUN apt-get update && apt-get install less

ADD Gemfile /app/
ADD Gemfile.lock /app/
ADD build /app/build
ADD .aptible.env /app/.aptible.env

WORKDIR /app

RUN bash /app/build/bundle.sh

ADD . /app

EXPOSE 9292