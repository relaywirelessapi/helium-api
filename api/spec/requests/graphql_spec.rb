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
end
