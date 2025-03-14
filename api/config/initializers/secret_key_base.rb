# typed: strict

Rails.application.config.secret_key_base = ENV.fetch("SECRET_KEY_BASE")
