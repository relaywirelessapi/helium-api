# typed: strict

class ApplicationMailer < ActionMailer::Base
  self.deliver_later_queue_name = "high"

  default from: ENV.fetch("FROM_ADDRESS")
  layout "mailer"
end
