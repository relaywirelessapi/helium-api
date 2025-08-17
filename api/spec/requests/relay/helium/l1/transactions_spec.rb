# typed: false

RSpec.describe "/helium/l1/transactions", type: :request do
  describe "GET /" do
    it "returns a list of transactions" do
      transaction = create(:helium_l1_transaction)

      api_get(helium_l1_transactions_path)

      expect(parsed_response).to be_paginated_collection.with([ transaction ])
    end

    it "filters transactions by type" do
      matching = create(:helium_l1_transaction, type: "payment_v1")
      create(:helium_l1_transaction, type: "poc_request_v1")

      api_get(helium_l1_transactions_path, params: { type: "payment_v1" })

      expect(parsed_response).to be_paginated_collection.with([ matching ])
    end
  end
end
