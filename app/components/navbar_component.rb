# typed: false
# frozen_string_literal: true

class NavbarComponent < ViewComponent::Base
  def links
    [
      {
        name: "Dashboard",
        path: root_path
      }
    ]
  end
end
