# typed: false

#Sidekiq::Client.reliable_push! unless Rails.env.test?

Sidekiq.configure_server do |config|
  #config.super_fetch!
  #config.reliable_scheduler!
end
