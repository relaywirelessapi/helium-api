# typed: false

RSpec.describe "/helium/l1/transaction-actors", type: :request do
  describe "GET /" do
    it "returns a list of transaction actors" do
      actor = create(:helium_l1_transaction_actor)

      api_get(helium_l1_transaction_actors_path)

      expect(parsed_response).to be_paginated_collection.with([ actor ])
    end

    it "filters by actor_role" do
      matching = create(:helium_l1_transaction_actor, actor_role: "challenger")
      create(:helium_l1_transaction_actor, actor_role: "payer")

      api_get(helium_l1_transaction_actors_path, params: { actor_role: "challenger" })

      expect(parsed_response).to be_paginated_collection.with([ matching ])
    end
  end
end
