# typed: strict
# frozen_string_literal: true

class FormContainerComponent < ViewComponent::Base
  extend T::Sig

  sig { params(title: String).void }
  def initialize(title:)
    @title = title
  end

  private

  sig { returns(String) }
  attr_reader :title
end
