# typed: false

RSpec.describe "/helium/l1/gateways", type: :request do
  describe "GET /" do
    it "returns a list of gateways" do
      gateway = create(:helium_l1_gateway)

      api_get(helium_l1_gateways_path)

      expect(parsed_response).to be_paginated_collection.with([ gateway ])
    end

    it "filters by owner_address" do
      matching = create(:helium_l1_gateway, owner: create(:helium_l1_account, address: "11111111111111111111111111111111"))
      create(:helium_l1_gateway, owner: create(:helium_l1_account, address: "22222222222222222222222222222222"))

      api_get(helium_l1_gateways_path, params: { owner_address: "11111111111111111111111111111111" })

      expect(parsed_response).to be_paginated_collection.with([ matching ])
    end
  end
end
