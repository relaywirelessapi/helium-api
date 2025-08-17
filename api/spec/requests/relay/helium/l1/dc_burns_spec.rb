# typed: false

RSpec.describe "/helium/l1/dc-burns", type: :request do
  describe "GET /" do
    it "returns a list of DC burns" do
      record = create(:helium_l1_dc_burn)

      api_get(helium_l1_dc_burns_path)

      expect(parsed_response).to be_paginated_collection.with([ record ])
    end

    it "filters by actor_address" do
      matching = create(:helium_l1_dc_burn, actor: create(:helium_l1_account, address: "11111111111111111111111111111111"))
      create(:helium_l1_dc_burn, actor: create(:helium_l1_account, address: "22222222222222222222222222222222"))

      api_get(helium_l1_dc_burns_path, params: { actor_address: "11111111111111111111111111111111" })

      expect(parsed_response).to be_paginated_collection.with([ matching ])
    end
  end
end
