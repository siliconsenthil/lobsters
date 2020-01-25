FROM simplhub/ruby-jemalloc-2.5.0:v1

RUN apt-get update -qq && apt-get install -y \
                                      build-essential \
                                      libpq-dev \
                                      libxml2-dev \
                                      libxslt1-dev \
                                      libmysqlclient-dev \
                                      git

RUN bundle config build.nio4r --with-cflags="-std=c99"
# for a JS runtime
RUN curl -sL https://deb.nodesource.com/setup_6.x |  bash && apt-get install nodejs && npm install -g yarn

ENV APP_HOME /lobsters
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ENV BUNDLER_VERSION=2.0.2
RUN gem install bundler --version=${BUNDLER_VERSION} --force
ADD Gemfile* $APP_HOME/
RUN bundle install --without test development

ADD . $APP_HOME

RUN mkdir -p tmp/pids

CMD ["./run-server.sh"]
