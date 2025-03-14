# typed: false

RSpec.describe "Dashboard", type: :system do
  it "displays the dashboard" do
    sign_in create(:user), scope: :user
    visit root_path
    expect(page).to have_content("Hello, world!")
  end
end
