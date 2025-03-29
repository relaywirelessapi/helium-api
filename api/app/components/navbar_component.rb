# typed: false
# frozen_string_literal: true

class NavbarComponent < ViewComponent::Base
  def links
    links = [
      {
        name: "Docs ↗",
        path: "https://docs.relaywireless.com",
        target: "_blank"
      }
    ]

    if helpers.user_signed_in?
      links += [
        {
          name: "Dashboard",
          path: root_path
        },
        {
          name: "Settings",
          path: edit_user_registration_path
        },
        {
          name: "Sign Out",
          path: destroy_user_session_path,
          data: { turbo_method: :delete }
        }
      ]
    end

    links
  end
end
