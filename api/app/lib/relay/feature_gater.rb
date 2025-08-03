# typed: strict

module Relay
  class FeatureGater
    extend T::Sig

    sig { returns(User) }
    attr_reader :user

    sig { params(user: User).void }
    def initialize(user)
      @user = user
    end

    sig { params(feature_name: Symbol).returns(T::Boolean) }
    def enabled?(feature_name)
      case feature_name
      when :billing
        !Rails.env.production? || user.email.ends_with?("@relaywireless.com") || user.email.ends_with?("@relaydevice.com")
      else
        raise "Unknown feature: #{feature_name}"
      end
    end
  end
end
