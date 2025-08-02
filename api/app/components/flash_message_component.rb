# typed: strict

class FlashMessageComponent < ViewComponent::Base
  extend T::Sig

  VALID_TYPES = T.let([ :notice, :alert, :error ], T::Array[Symbol])

  sig { params(type: Symbol, message: String).void }
  def initialize(type:, message:)
    raise ArgumentError, "Invalid flash message type: #{type}" unless VALID_TYPES.include?(type.to_sym)

    @type = type
    @message = message
  end
end
