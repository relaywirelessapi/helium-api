# typed: false

RSpec.describe "/helium/l1/accounts", type: :request do
  describe "GET /" do
    it "returns a list of accounts" do
      account = create(:helium_l1_account)

      api_get(helium_l1_accounts_path)

      expect(parsed_response).to be_paginated_collection.with([ account ])
    end

    it "filters accounts by address" do
      matching_account = create(:helium_l1_account, address: "11111111111111111111111111111111")
      create(:helium_l1_account, address: "22222222222222222222222222222222")

      api_get(helium_l1_accounts_path, params: { address: "11111111111111111111111111111111" })

      expect(parsed_response).to be_paginated_collection.with([ matching_account ])
    end
  end

  describe "GET /:id" do
    it "allows retrieving accounts by ID" do
      account = create(:helium_l1_account)

      api_get(helium_l1_account_path(account.id))

      expect(parsed_response).to include("id" => account.id)
    end

    it "allows retrieving accounts by address" do
      account = create(:helium_l1_account, address: "11111111111111111111111111111111")

      api_get(helium_l1_account_path("11111111111111111111111111111111"))

      expect(parsed_response).to include("id" => account.id)
    end
  end
end
