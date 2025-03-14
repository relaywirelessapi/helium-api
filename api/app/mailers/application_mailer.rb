# typed: strict

class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("FROM_ADDRESS")
  layout "mailer"
end
