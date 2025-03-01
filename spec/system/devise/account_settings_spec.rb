# typed: false

require "rails_helper"

RSpec.describe "Account settings", type: :system do
  it "allows authenticated users to update their account" do
    user = create(:user)
    sign_in user, scope: :user
    visit edit_user_registration_path

    fill_in "Email", with: "newemail@example.com"
    fill_in "Current password", with: user.password
    click_button "Update"

    expect(page).to have_content("You updated your account successfully")
  end

  it "allows users to cancel their account", js: true do
    user = create(:user)
    sign_in user, scope: :user

    visit edit_user_registration_path
    accept_confirm { click_link "Cancel my account" }

    expect(page).to have_content("You need to sign in or sign up before continuing.")
    expect(current_path).to eq(new_user_session_path)
    expect(Relay::User.exists?(user.id)).to be(false)
  end
end
