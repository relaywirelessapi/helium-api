# typed: strict

class IconComponent < ViewComponent::Base
  extend T::Sig

  sig { params(name: Symbol, size: Symbol, color: Symbol).void }
  def initialize(name:, size: :md, color: :gray)
    @name = name
    @size = size
    @color = color
  end

  private

  sig { returns(Symbol) }
  attr_reader :name

  sig { returns(Symbol) }
  attr_reader :size

  sig { returns(Symbol) }
  attr_reader :color

  sig { returns(String) }
  def size_classes
    case size
    when :sm
      "w-4 h-4"
    when :md
      "w-5 h-5"
    when :lg
      "w-6 h-6"
    when :xl
      "w-8 h-8"
    else
      "w-5 h-5"
    end
  end

  sig { returns(String) }
  def color_classes
    case color
    when :green
      "text-green-500"
    when :blue
      "text-blue-500"
    when :red
      "text-red-500"
    when :yellow
      "text-yellow-500"
    when :gray
      "text-gray-500"
    else
      "text-gray-500"
    end
  end

  sig { returns(String) }
  def css_classes
    "#{size_classes} #{color_classes}"
  end
end
