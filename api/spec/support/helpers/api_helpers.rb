# typed: false

module ApiHelpers
  def api_get(path, params: {}, headers: {})
    current_user = create(:user)

    get(path, params: params, headers: headers.reverse_merge(
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{current_user.api_key}"
    ))
  end
end

RSpec.configure do |config|
  config.include ApiHelpers, type: :request
end
