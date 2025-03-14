# typed: false

module GraphqlHelpers
  def execute_graphql_query(query, api_key: nil, variables: {})
    post(
      graphql_path,
      params: {
        query: query,
        variables: variables
      }.to_json,
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{api_key}"
      }
    )
  end
end

RSpec.configure do |config|
  config.include GraphqlHelpers, type: :request
end
