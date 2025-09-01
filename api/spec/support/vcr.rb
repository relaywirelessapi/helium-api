# typed: strict

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.ignore_localhost = true

  config.ignore_request do |request|
    # Allow requests to Chrome WebDriver hub
    request.uri.include?('chrome:4444/')
  end

  config.filter_sensitive_data("<SOLANA_RPC_URL>") do |interaction|
    ENV.fetch("SOLANA_RPC_URL")
  end
end
