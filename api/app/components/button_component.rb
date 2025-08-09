# typed: strict

class ButtonComponent < ViewComponent::Base
  extend T::Sig

  sig { params(text: String, style: Symbol, href: T.nilable(String), full_width: T::Boolean, size: Symbol, options: T.untyped).void }
  def initialize(text:, style:, href: nil, full_width: false, size: :m, **options)
    @text = text
    @style = style
    @href = href
    @full_width = full_width
    @size = size
    @options = options
  end

  private

  sig { returns(String) }
  attr_reader :text

  sig { returns(Symbol) }
  attr_reader :style

  sig { returns(T.nilable(String)) }
  attr_reader :href

  sig { returns(T::Boolean) }
  attr_reader :full_width

  sig { returns(Symbol) }
  attr_reader :size

  sig { returns(T.untyped) }
  attr_reader :options
end
