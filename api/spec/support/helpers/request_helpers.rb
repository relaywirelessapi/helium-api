# typed: false

module RequestHelpers
  def parsed_response
    JSON.parse(response.body)
  end
end

RSpec.configure do |config|
  config.include RequestHelpers, type: :request
end
