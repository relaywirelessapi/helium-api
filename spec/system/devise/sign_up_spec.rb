# typed: false

require "rails_helper"

RSpec.describe "Devise Sign Up", type: :system do
  describe "Sign up" do
    it "allows new users to register" do
      visit new_user_registration_path

      fill_in "Email", with: "newuser@example.com"
      fill_in "Password", with: "password123"
      fill_in "Password confirmation", with: "password123"

      click_button "Sign up"

      expect(page).to have_content("A message with a confirmation link has been sent to your email address")
    end
  end
end
