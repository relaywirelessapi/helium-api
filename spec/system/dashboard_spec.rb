# typed: false

RSpec.describe "Dashboard", type: :system do
  it "displays the dashboard" do
    visit root_path
    expect(page).to have_content("Hello, world!")
    save_screenshot(Rails.root.join("tmp/screenshots/screenshot.png"))
  end
end
