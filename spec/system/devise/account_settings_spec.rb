# typed: false

require "rails_helper"

RSpec.describe "Devise Account Settings", type: :system do
  describe "Account Settings" do
    it "allows authenticated users to update their account" do
      user = create(:user)
      sign_in user
      visit edit_user_registration_path

      fill_in "Email", with: "newemail@example.com"
      fill_in "Current password", with: user.password
      click_button "Update"

      expect(page).to have_content("You updated your account successfully")
    end
  end
end
