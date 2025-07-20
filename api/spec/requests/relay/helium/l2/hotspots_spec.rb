# typed: false

RSpec.describe "/helium/l2/hotspots", type: :request do
  describe "GET /" do
    it "returns a list of hotspots" do
      hotspot = create(:hotspot)

      api_get(helium_l2_hotspots_path)

      expect(parsed_response).to be_paginated_collection.with([ hotspot ])
    end

    it "allows filtering by owner" do
      hotspot = create(:hotspot, owner: "owner123")
      create(:hotspot, owner: "owner456")

      api_get(helium_l2_hotspots_path(owner: "owner123"))

      expect(parsed_response).to be_paginated_collection.with([ hotspot ])
    end

    it "allows filtering by asset_id" do
      hotspot = create(:hotspot, asset_id: "asset123")
      create(:hotspot, asset_id: "asset456")

      api_get(helium_l2_hotspots_path(asset_id: "asset123"))

      expect(parsed_response).to be_paginated_collection.with([ hotspot ])
    end

    it "allows filtering by ecc_key" do
      hotspot = create(:hotspot, ecc_key: "ecc123")
      create(:hotspot, ecc_key: "ecc456")

      api_get(helium_l2_hotspots_path(ecc_key: "ecc123"))

      expect(parsed_response).to be_paginated_collection.with([ hotspot ])
    end

    it "allows filtering by maker_id" do
      maker1 = create(:helium_l2_maker)
      maker2 = create(:helium_l2_maker)
      hotspot = create(:hotspot, maker: maker1)
      create(:hotspot, maker: maker2)

      api_get(helium_l2_hotspots_path(maker_id: maker1.id))

      expect(parsed_response).to be_paginated_collection.with([ hotspot ])
    end

    it "allows filtering by network" do
      create(:hotspot, networks: [ "iot" ])
      mobile_hotspot = create(:hotspot, networks: [ "mobile" ])
      dual_hotspot = create(:hotspot, networks: [ "iot", "mobile" ])

      api_get(helium_l2_hotspots_path(networks: "mobile"))

      expect(parsed_response).to be_paginated_collection.with([ mobile_hotspot, dual_hotspot ])
    end
  end
end
