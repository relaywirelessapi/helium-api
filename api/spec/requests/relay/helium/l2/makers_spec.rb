# typed: false

RSpec.describe "/helium/l2/makers", type: :request do
  describe "GET /" do
    it "returns a list of makers" do
      maker = create(:helium_l2_maker)

      api_get(helium_l2_makers_path)

      expect(parsed_response).to be_paginated_collection.with([ maker ])
    end
  end
end
