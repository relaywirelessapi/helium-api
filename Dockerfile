# syntax=docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.4.1
FROM docker.io/library/ruby:$RUBY_VERSION

# Install dependencies
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y \
  build-essential \
  git \
  libpq-dev \
  pkg-config \
  curl \
  libpq5 \
  postgresql-client && \
  rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

# Set up application
WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs "$(nproc)" --retry 3
RUN gem install foreman

# Copy application code
COPY . .

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/dev"]
