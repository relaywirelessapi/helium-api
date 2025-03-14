# typed: false
# frozen_string_literal: true

class NavbarComponent < ViewComponent::Base
  def links
    if helpers.user_signed_in?
      [
        {
          name: "Dashboard",
          path: root_path
        },
        {
          name: "Profile",
          path: edit_user_registration_path
        },
        {
          name: "Sign Out",
          path: destroy_user_session_path,
          data: { turbo_method: :delete }
        }
      ]
    else
      [
        {
          name: "Sign In",
          path: new_user_session_path
        },
        {
          name: "Sign Up",
          path: new_user_registration_path
        }
      ]
    end
  end
end
