# typed: false

require "rails_helper"

RSpec.describe "GraphQL usage limits", type: :request do
  it "increments usage when executing queries" do
    query = <<~GRAPHQL
      query {
        status
      }
    GRAPHQL
    user = create(:user)

    execute_graphql_query(query, api_key: user.api_key)

    expect(user.reload.current_api_usage).to eq(1)
  end

  it "returns an error when usage limit is going to be exceeded" do
    query = <<~GRAPHQL
      query {
        status
      }
    GRAPHQL
    user = create(:user, current_api_usage: 10_000)

    execute_graphql_query(query, api_key: user.api_key)

    expect(parsed_response["errors"]).to include(
      hash_including(
        "message" => match(/Usage limit will be exceeded with current query/)
      )
    )
  end
end
