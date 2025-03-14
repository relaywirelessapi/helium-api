# typed: false
# frozen_string_literal: true

class CardComponent < ViewComponent::Base
  def initialize(class_names: "")
    @class_names = class_names
  end

  private

  attr_reader :class_names
end
