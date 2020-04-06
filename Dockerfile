FROM ruby:2.5

RUN apt-get update -qq && apt-get install -y build-essential

ENV TERM xterm-256color
ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

RUN gem install bundler

ADD Gemfile* $APP_HONE/

RUN bundle config set without 'development test'
RUN bundle install

ADD . $APP_HOME

RUN ./install

EXPOSE 3000

CMD ["./beef"]