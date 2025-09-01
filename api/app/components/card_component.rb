# typed: strict

class CardComponent < ViewComponent::Base
  extend T::Sig

  sig { params(class_names: T.nilable(String), title: T.nilable(String), color: T.nilable(Symbol)).void }
  def initialize(class_names: "", title: nil, color: :white)
    @class_names = class_names
    @title = title
    @color = color
  end
end
