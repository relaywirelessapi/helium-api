# typed: false

require "rails_helper"

RSpec.describe Relay::Solana::Client do
  describe "#get_assets_by_group" do
    it "handles pagination and returns all assets" do
      mock_client = instance_double(SolanaRuby::HttpClient)
      allow(mock_client).to receive(:request)
        .with("getAssetsByGroup", { groupKey: "collection", groupValue: "test", page: 1, limit: 2 })
        .and_return(create_mock_response(
          total: 3,
          limit: 2,
          page: 1,
          items: [ create_asset_item("asset1"), create_asset_item("asset2") ]
        ))
      allow(mock_client).to receive(:request)
        .with("getAssetsByGroup", { groupKey: "collection", groupValue: "test", page: 2, limit: 2 })
        .and_return(create_mock_response(
          total: 3,
          limit: 2,
          page: 2,
          items: [ create_asset_item("asset3") ]
        ))
      allow(mock_client).to receive(:request)
        .with("getAssetsByGroup", { groupKey: "collection", groupValue: "test", page: 3, limit: 2 })
        .and_return(create_mock_response(
          total: 3,
          limit: 2,
          page: 3,
          items: []
        ))

      client = described_class.new(client: mock_client)
      result = client.get_assets_by_group(groupKey: "collection", groupValue: "test", limit: 2).to_a

      expect(result).to eq([
        create_asset_item("asset1"),
        create_asset_item("asset2"),
        create_asset_item("asset3")
      ])
    end

    define_method(:create_mock_response) do |total:, limit:, page:, items:|
      {
        "jsonrpc" => "2.0",
        "result" => {
          "total" => total,
          "limit" => limit,
          "page" => page,
          "items" => items
        }
      }
    end

    define_method(:create_asset_item) do |id|
      { "id" => id, "interface" => "ProgrammableNFT" }
    end
  end
end
