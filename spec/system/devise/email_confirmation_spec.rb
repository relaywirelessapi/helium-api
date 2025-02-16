# typed: false

require "rails_helper"

RSpec.describe "Devise Email Confirmation", type: :system do
  describe "Email Confirmation" do
    it "allows users to request new confirmation instructions" do
      unconfirmed_user = create(:user, confirmed_at: nil)
      visit new_user_confirmation_path

      fill_in "Email", with: unconfirmed_user.email
      click_button "Resend confirmation instructions"

      expect(page).to have_content("You will receive an email with instructions")
    end
  end
end
