# typed: false

require "rails_helper"

RSpec.describe "Devise Sign In", type: :system do
  describe "Sign in" do
    it "allows users to sign in with valid credentials" do
      user = create(:user)
      visit new_user_session_path

      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Sign in"

      expect(page).to have_content("Signed in successfully")
    end
  end
end
