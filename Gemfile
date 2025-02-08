source "https://rubygems.org"

# Ruby on Rails
gem "rails", "~> 8.0.1"

# Web infrastructure
gem "puma", ">= 5.0"
gem "bootsnap", require: false
gem "thruster", require: false

# ActiveRecord
gem "pg", "~> 1.1"

# ActiveJob
gem "sidekiq"

# Frontend
gem "propshaft"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"

# Type checking
gem "sorbet", group: :development
gem "sorbet-runtime"
gem "sorbet-rails"
gem "spoom", group: :development
gem "tapioca", require: false, group: :development # For generating RBI files

# Development and testing
group :development, :test do
  # Debugging
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"

  # Static analysis
  gem "brakeman", require: false
  gem "rubocop"
  gem "rubocop-sorbet", require: false
  gem "rubocop-rails-omakase", require: false

  # Tesing
  gem "rspec-rails"
  gem "capybara"
  gem "factory_bot_rails"
  gem "faker"
end
