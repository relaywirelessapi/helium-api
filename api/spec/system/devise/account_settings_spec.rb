# typed: false

require "rails_helper"

RSpec.describe "Account settings", type: :system do
  it "allows authenticated users to update their email" do
    user = create(:user, password: "password")
    sign_in user, scope: :user
    visit edit_user_registration_path

    within "form#account-information-form" do
      fill_in "Email", with: "newemail@example.com"
      fill_in "Current password", with: "password"
      click_button "Save Changes"
    end

    aggregate_failures do
      expect(page).to have_content("You updated your account successfully")
      expect(user.reload.unconfirmed_email).to eq("newemail@example.com")
    end
  end

  it "allows authenticated users to update their password" do
    user = create(:user, password: "password")
    sign_in user, scope: :user
    visit edit_user_registration_path

    within "form#security-form" do
      fill_in "Password", with: "newpassword"
      fill_in "Password confirmation", with: "newpassword"
      fill_in "Current password", with: "password"
      click_button "Update Password"
    end

    aggregate_failures do
      expect(page).to have_content("Your account has been updated successfully")
      expect(user.reload.valid_password?("newpassword")).to be true
    end
  end

  it "allows authenticated users to log out" do
    user = create(:user)
    sign_in user, scope: :user

    visit edit_user_registration_path
    click_button "Log out"

    expect(page).to have_content("Signed out successfully")
  end
end
