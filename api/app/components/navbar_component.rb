# typed: strict
# frozen_string_literal: true

class NavbarComponent < ViewComponent::Base
  extend T::Sig

  sig { returns(T::Array[T::Hash[Symbol, String]]) }
  def links
    [
      {
        name: "Dashboard",
        path: helpers.root_path
      },
      {
        name: "Docs ↗",
        path: "https://docs.relaywireless.com",
        target: "_blank"
      },
      {
        name: "Settings",
        path: helpers.edit_user_registration_path
      }
    ]
  end
end
