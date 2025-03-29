# typed: false
# frozen_string_literal: true

class NavbarComponent < ViewComponent::Base
  def links
    [
      {
        name: "Dashboard",
        path: root_path
      },
      {
        name: "Docs ↗",
        path: "https://docs.relaywireless.com",
        target: "_blank"
      },
      {
        name: "Settings",
        path: edit_user_registration_path
      }
    ]
  end
end
