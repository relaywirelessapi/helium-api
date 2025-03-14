# typed: false

Selenium::WebDriver.logger.level = :fatal

Capybara.app_host = "http://#{IPSocket.getaddress(Socket.gethostname)}:3010"

Capybara.server_host = '0.0.0.0'
Capybara.server_port = '3010'

Capybara.register_driver :remote_selenium do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--headless")
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--window-size=1400,1400")

  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: "http://chrome:4444/wd/hub",
    options: options,
  )
end

Capybara.javascript_driver = :remote_selenium
Capybara.default_driver = :remote_selenium

Capybara.always_include_port = true

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :remote_selenium
  end
end
