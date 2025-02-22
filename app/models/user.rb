# typed: false

class User < ApplicationRecord
  extend T::Sig

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable, :trackable

  before_create :refresh_api_key

  sig { void }
  def refresh_api_key
    self.api_key = SecureRandom.hex(32)
  end

  sig { void }
  def refresh_api_key!
    refresh_api_key
    save!
  end

  sig { params(notification: T.untyped, args: T.untyped).void }
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
