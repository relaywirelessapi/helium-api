# typed: false

RSpec.describe Relay::Solana::Transaction do
  describe ".from_rpc" do
    it "decodes the accounts properly" do
      response = JSON.parse(File.read(Rails.root.join("spec/fixtures/helius-webhook.json"))).first

      transaction = described_class.from_rpc(response)

      expect(transaction.accounts).to match_array([
        "jiNgvi49z1seEpnByq5rhYc2TMqGKg6r8CPVdCdZmnA",
        "41avWapVL9m7ueaZhqVXuYypkfSSAFLPiKnyWkqK5FH4",
        "9eVGdh9PH3E2mUTdHzr2fAgtSxXi4JRo8K2mpQSymzhe",
        "dcuc8Amr83Wz27ZkQ2K9NS6r8zRpf1J6cvArEBDZDmm",
        "11111111111111111111111111111111",
        "2x1ydLC4tGjSWdJCkKHf1WQJdxbmYmYAcbFd11apR9dH",
        "35fDMBCBduP8Hxhv1dqj8ASmcrSEGxdrV3ZPpQKPLdCt",
        "35HAgDQY3WpgJT4ymb8gjaP1dQNZX6wTkThd84Q9qzwH",
        "39Lw1RH6zt8AJvKn3BTxmUDofzduCM2J3kSaGDZ8L7Sk",
        "4Nk7mK3U8XP25bQkK84kaazZEv9ztPzk875eoGRtVQnT",
        "51Dgaa1iwce17FY18M7mDcTSgKeDLqMqEqYnnNNBEv8m",
        "8nyQLJWp3nyF73fqmKvonLaZSW4sqDnuqepjQp4vYYxi",
        "ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL",
        "BGUMAp9Gq7iTEuizy4pqaxsTyUCBK68MDfK752saRPUY",
        "BQ3MCuTT5zVBhNfQ4SjMh3NPVhFy73MPV8rjfq5d1zie",
        "cmtDvXumGCrqC1Age74AVPhSRVXJMd8PJS91L8KbNCK",
        "ComputeBudget111111111111111111111111111111",
        "credMBJhYFzfn7NxBMdU4aUqFggAjgztaCcv2Fo6fPT",
        "D1LbvrJQ9K2WbGPMbM3Fnrf5PSsDH1TDpjqJdHuvs81n",
        "hemjuPXBpNvggtaUnN1MwT3wrdhttKEfosTcc2P9Pg8",
        "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA"
      ])
    end

    it "decodes the instructions properly" do
      response = JSON.parse(File.read(Rails.root.join("spec/fixtures/helius-webhook.json"))).first

      transaction = described_class.from_rpc(response)

      expect(transaction.instructions).to match_array([
        have_attributes(
          program_index: 16,
          account_indices: [],
          data: "Fj2Eoy",
        ),
        have_attributes(
          program_index: 16,
          account_indices: [],
          data: "3GAG5eogvTjV",
        ),
        have_attributes(
          program_index: 19,
          account_indices: [ 0, 0, 2, 0, 11, 10, 1, 7, 14, 8, 3, 18, 13, 15, 17, 20, 12, 4, 9, 5, 6 ],
          data: "5uy6njmBG1vs3N5kjSEEZYVWQPqAe4JuzCNKU1RXRXe7HUEu9h6R6posxHn6ZVatTzsJNMo9RGwAqQPyZFuZQ5Dn37Rb7xQ24H8wqSGTBdqn4AEroS927eiHvacBLDQfWbh3ZytbK1XEE1H8jSUAMmcj4WShKbTH527fJPBHR4cJqM",
        )
      ])
    end
  end
end
