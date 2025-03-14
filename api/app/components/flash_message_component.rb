# typed: true
# frozen_string_literal: true

class FlashMessageComponent < ViewComponent::Base
  VALID_TYPES = [ :notice, :alert, :error ].freeze

  def initialize(type:, message:)
    raise ArgumentError, "Invalid flash message type: #{type}" unless VALID_TYPES.include?(type.to_sym)

    @type = type
    @message = message
  end
end
