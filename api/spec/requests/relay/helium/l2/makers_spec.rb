# typed: false

RSpec.describe "/helium/l2/makers", type: :request do
  describe "GET /" do
    it "returns a list of makers" do
      maker = create(:helium_l2_maker)

      api_get(helium_l2_makers_path)

      expect(parsed_response).to be_paginated_collection.with([ maker ])
    end
  end

  describe "GET /:id" do
    it "allows retrieving makers by ID" do
      maker = create(:helium_l2_maker)

      api_get(helium_l2_maker_path(maker.id))

      expect(parsed_response).to include("id" => maker.id)
    end

    it "allows retrieving makers by address" do
      maker = create(:helium_l2_maker, address: "address123")

      api_get(helium_l2_maker_path("address123"))

      expect(parsed_response).to include("id" => maker.id)
    end
  end
end
