# typed: true
# frozen_string_literal: true

class FormContainerComponent < ViewComponent::Base
  def initialize(title:)
    @title = title
  end

  private

  attr_reader :title
end
