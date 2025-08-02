# typed: strict
# frozen_string_literal: true

class BadgeComponent < ViewComponent::Base
  extend T::Sig

  sig { params(variant: Symbol).void }
  def initialize(variant: :default)
    @variant = variant
  end

  private

  sig { returns(Symbol) }
  attr_reader :variant

  sig { returns(Symbol) }
  attr_reader :variant

  sig { returns(String) }
  def css_classes
    case variant
    when :blue
      "bg-blue-100 text-blue-800"
    when :green
      "bg-green-100 text-green-800"
    when :red
      "bg-red-100 text-red-800"
    when :yellow
      "bg-yellow-100 text-yellow-800"
    when :gray
      "bg-gray-100 text-gray-800"
    else
      "bg-gray-100 text-gray-800"
    end + " px-2 py-0.5 rounded-full text-xs font-medium"
  end
end
