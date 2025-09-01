# typed: false

RSpec.describe "/helium/l1/rewards", type: :request do
  describe "GET /" do
    it "returns a list of rewards" do
      reward = create(:helium_l1_reward)

      api_get(helium_l1_rewards_path)

      expect(parsed_response).to be_paginated_collection.with([ reward ])
    end

    it "filters by account_address" do
      matching_account = create(:helium_l1_account, address: "11111111111111111111111111111111")
      other_account = create(:helium_l1_account, address: "22222222222222222222222222222222")
      matching = create(:helium_l1_reward, account: matching_account)
      create(:helium_l1_reward, account: other_account)

      api_get(helium_l1_rewards_path, params: { account_address: "11111111111111111111111111111111" })

      expect(parsed_response).to be_paginated_collection.with([ matching ])
    end
  end
end
