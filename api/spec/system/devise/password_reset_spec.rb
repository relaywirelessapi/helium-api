# typed: false

require "rails_helper"

RSpec.describe "Password reset", type: :system do
  it "allows users to request password reset" do
    user = create(:user)
      visit new_user_password_path

      fill_in "Email", with: user.email
      click_button "Send me reset password instructions"

    expect(page).to have_content("You will receive an email with instructions")
  end
end
