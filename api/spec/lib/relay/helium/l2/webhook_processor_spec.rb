# typed: false

RSpec.describe Relay::Helium::L2::WebhookProcessor do
    it "decodes and stores the webhook instructions" do
      payload = JSON.parse(File.read(Rails.root.join("spec/fixtures/helius-webhook.json")))
      webhook = Relay::Webhooks::Webhook.create!(payload: payload, source: "helius")

      processor = described_class.new
      processor.process(webhook)

      expect(webhook.reload.metadata).to eq([
        [
          nil,
          nil,
          {
            "args" => {
              "args" => {
                "gain" => 60,
                "root" => [
                  192, 32, 25, 60, 195, 104, 201, 83, 98, 104, 177, 121, 43, 151, 52, 132, 7, 174, 89, 187, 213, 88, 202, 173, 139, 81, 164, 166, 120, 30, 121, 146
                ],
                "index" => 66882,
                "location" => 631197518555928575,
                "data_hash" => [
                  25, 199, 24, 25, 46, 141, 18, 226, 8, 80, 20, 229, 123, 213, 39, 209, 156, 152, 213, 207, 177, 93, 90, 163, 202, 145, 221, 154, 55, 78, 188, 162
                ],
                "elevation" => 6,
                "creator_hash" => [
                  236, 61, 33, 247, 100, 77, 44, 37, 95, 236, 99, 186, 8, 11, 30, 39, 118, 180, 104, 118, 206, 182, 49, 175, 32, 50, 36, 89, 154, 121, 211, 253
                ]
              }
            },
            "accounts" => {
              "dc" => "D1LbvrJQ9K2WbGPMbM3Fnrf5PSsDH1TDpjqJdHuvs81n",
              "dao" => "BQ3MCuTT5zVBhNfQ4SjMh3NPVhFy73MPV8rjfq5d1zie",
              "payer" => "jiNgvi49z1seEpnByq5rhYc2TMqGKg6r8CPVdCdZmnA",
              "dc_mint" => "dcuc8Amr83Wz27ZkQ2K9NS6r8zRpf1J6cvArEBDZDmm",
              "sub_dao" => "39Lw1RH6zt8AJvKn3BTxmUDofzduCM2J3kSaGDZ8L7Sk",
              "iot_info" => "9eVGdh9PH3E2mUTdHzr2fAgtSxXi4JRo8K2mpQSymzhe",
              "dc_burner" => "41avWapVL9m7ueaZhqVXuYypkfSSAFLPiKnyWkqK5FH4",
              "merkle_tree" => "8nyQLJWp3nyF73fqmKvonLaZSW4sqDnuqepjQp4vYYxi",
              "dc_fee_payer" => "jiNgvi49z1seEpnByq5rhYc2TMqGKg6r8CPVdCdZmnA",
              "hotspot_owner" => "jiNgvi49z1seEpnByq5rhYc2TMqGKg6r8CPVdCdZmnA",
              "token_program" => "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA",
              "system_program" => "11111111111111111111111111111111",
              "tree_authority" => "51Dgaa1iwce17FY18M7mDcTSgKeDLqMqEqYnnNNBEv8m",
              "bubblegum_program" => "BGUMAp9Gq7iTEuizy4pqaxsTyUCBK68MDfK752saRPUY",
              "compression_program" => "cmtDvXumGCrqC1Age74AVPhSRVXJMd8PJS91L8KbNCK",
              "data_credits_program" => "credMBJhYFzfn7NxBMdU4aUqFggAjgztaCcv2Fo6fPT",
              "associated_token_program" => "ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL",
              "rewardable_entity_config" => "35HAgDQY3WpgJT4ymb8gjaP1dQNZX6wTkThd84Q9qzwH"
            },
            "instruction" => "update_iot_info_v0"
          }
        ]
      ])
    end
  end
