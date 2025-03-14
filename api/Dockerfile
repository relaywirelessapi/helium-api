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
RUN bundle config set --local without 'development test' && \
  bundle install --jobs "$(nproc)" --retry 3

# Copy application code
COPY . .

# Set production environment
ENV RAILS_ENV=production \
  RAILS_LOG_TO_STDOUT=true \
  RAILS_SERVE_STATIC_FILES=true

# Precompile assets (ENV variables required because of https://github.com/rails/rails/issues/32947)
RUN SECRET_KEY_BASE=8128b3009d7ef66c73c9f2fe824e660e51b45a83f36c91bf142f11e62b4818ddc7d041e1b69be278324db2a6f7f2fcc9593f31cad0f0af506c1771676dd9a35c \
  DEVISE_PEPPER=a447247de939714667de802c7d4ed2884815ac7afb5c9e65e2aeb9e14fb5e19286bf5ee7b31f2f74e69ce31a801220a95601453d1c16c4919ae745379bf8a1e5 \  
  DOMAIN_NAME=example.com \
  REDIS_URL=redis://localhost:6379 \
  SMTP_USERNAME=YourSmtpUsername \
  SMTP_PASSWORD=YourSmtpPassword \
  SMTP_ADDRESS=smtp.example.com \
  FROM_ADDRESS=noreply@example.com \
  bundle exec rails assets:precompile

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
