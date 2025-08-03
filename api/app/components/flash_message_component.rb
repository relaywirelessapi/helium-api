# typed: strict

class FlashMessageComponent < ViewComponent::Base
  extend T::Sig

  VALID_TYPES = T.let([ :notice, :alert, :error, :info ], T::Array[Symbol])

  sig { params(type: Symbol, message: T.nilable(String)).void }
  def initialize(type:, message: nil)
    raise ArgumentError, "Invalid flash message type: #{type}" unless VALID_TYPES.include?(type.to_sym)

    @type = type
    @message = message
  end
end
