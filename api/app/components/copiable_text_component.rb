# typed: strict

class CopiableTextComponent < ViewComponent::Base
  extend T::Sig

  sig { params(text: String, button_text: String, input_classes: String, button_classes: String).void }
  def initialize(text:, button_text: "Copy", input_classes: "", button_classes: "")
    @text = text
    @button_text = button_text
    @input_classes = input_classes
    @button_classes = button_classes
  end

  private

  sig { returns(String) }
  attr_reader :text

  sig { returns(String) }
  attr_reader :button_text

  sig { returns(String) }
  attr_reader :input_classes

  sig { returns(String) }
  attr_reader :button_classes
end
