# typed: false

require "rails_helper"

RSpec.describe "/graphql", type: :request do
  describe "POST /" do
    it "allows access with valid API key" do
      user = create(:user)
      query = <<~GRAPHQL
        query { status }
      GRAPHQL

      execute_graphql_query(query, api_key: user.api_key)

      expect(parsed_response["data"]["status"]).to eq("ok")
    end

    it "denies access without an API key" do
      query = <<~GRAPHQL
        query { testField }
      GRAPHQL

      execute_graphql_query(query)

      expect(parsed_response["errors"]).to include(hash_including("message" => "Not authenticated"))
      expect(response).to have_http_status(:unauthorized)
    end

    it "denies access with invalid API key" do
      query = <<~GRAPHQL
        query { testField }
      GRAPHQL

      execute_graphql_query(query, api_key: "invalid")

      expect(parsed_response["errors"]).to include(hash_including("message" => "Not authenticated"))
      expect(response).to have_http_status(:unauthorized)
    end

    it "handles variables correctly" do
      query = <<~GRAPHQL
        query($message: String!) {
          echo(message: $message)
        }
      GRAPHQL

      execute_graphql_query(query, api_key: create(:user).api_key, variables: { message: "Hello!" })

      expect(response).to have_http_status(:ok)
      expect(parsed_response["data"]["echo"]).to eq("Hello!")
    end
  end
end
