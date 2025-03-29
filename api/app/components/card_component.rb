# typed: true
# frozen_string_literal: true

class CardComponent < ViewComponent::Base
  def initialize(class_names: "", title: nil)
    @class_names = class_names
    @title = title
  end

  private

  attr_reader :class_names, :title
end
