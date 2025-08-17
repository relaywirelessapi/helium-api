# typed: false

RSpec.describe "/helium/l1/packets", type: :request do
  describe "GET /" do
    it "returns a list of packets" do
      packet = create(:helium_l1_packet)

      api_get(helium_l1_packets_path)

      expect(parsed_response).to be_paginated_collection.with([ packet ])
    end

    it "filters by gateway_address" do
      matching_gateway = create(:helium_l1_gateway, address: "11111111111111111111111111111111")
      other_gateway = create(:helium_l1_gateway, address: "22222222222222222222222222222222")
      matching = create(:helium_l1_packet, gateway: matching_gateway)
      create(:helium_l1_packet, gateway: other_gateway)

      api_get(helium_l1_packets_path, params: { gateway_address: "11111111111111111111111111111111" })

      expect(parsed_response).to be_paginated_collection.with([ matching ])
    end
  end
end
