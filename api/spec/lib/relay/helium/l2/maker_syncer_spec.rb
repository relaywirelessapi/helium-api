# typed: false

RSpec.describe Relay::Helium::L2::MakerSyncer do
  describe "#list_makers" do
    it "returns the list of makers" do
      program_client = instance_double(Relay::Solana::ProgramClient).tap do |client|
        allow(client).to receive(:get_accounts).with("MakerV0").and_return([
          { "pubkey" => "address", "account" => { "data" => [ "base64_encoded_data" ] } }
        ])
      end

      maker_syncer = described_class.new(program_client:)

      expect(maker_syncer.list_makers).to eq([
        { "pubkey" => "address", "account" => { "data" => [ "base64_encoded_data" ] } }
      ])
    end
  end

  describe "#sync_maker" do
    it "syncs the maker starting from the account address and data" do
      program_client = instance_double(Relay::Solana::ProgramClient)

      maker_syncer = described_class.new(program_client:)
      maker_syncer.sync_maker("address", {
        "update_authority" => "EosEN92LercxMNWMtuSzxYCM4S7HZaLdJcEDLMKefvvS",
        "issuing_authority" => "4gQwHW4Sy9SGfjrNn1ALgVcHYcbBHA1p2F4NWVmoqRkN",
        "name" => "Kerlink",
        "bump_seed" => 253,
        "collection" => "H2JqAkscxETTtGzraycbUHGBmRVDR3PKv9cTH8ZbnA8y",
        "merkle_tree" => "DygaWE677oxFuGAto4HnqiFgnsUMAsGAnpeiE9Q8m4m1",
        "collection_bump_seed" => 254,
        "dao" => "11111111111111111111111111111111"
      })

      expect(Relay::Helium::L2::Maker.find_by(address: "address")).to have_attributes(
        update_authority: "EosEN92LercxMNWMtuSzxYCM4S7HZaLdJcEDLMKefvvS",
        issuing_authority: "4gQwHW4Sy9SGfjrNn1ALgVcHYcbBHA1p2F4NWVmoqRkN",
        name: "Kerlink",
        bump_seed: 253,
        collection: "H2JqAkscxETTtGzraycbUHGBmRVDR3PKv9cTH8ZbnA8y",
        merkle_tree: "DygaWE677oxFuGAto4HnqiFgnsUMAsGAnpeiE9Q8m4m1",
        collection_bump_seed: 254,
        dao: "11111111111111111111111111111111"
      )
    end
  end

  describe "#get_and_sync_maker" do
    it "syncs the maker starting from the account address" do
      program_client = instance_double(Relay::Solana::ProgramClient).tap do |client|
        allow(client).to receive(:get_and_deserialize_account).with("address").and_return({
          "update_authority" => "EosEN92LercxMNWMtuSzxYCM4S7HZaLdJcEDLMKefvvS",
          "issuing_authority" => "4gQwHW4Sy9SGfjrNn1ALgVcHYcbBHA1p2F4NWVmoqRkN",
          "name" => "Kerlink",
          "bump_seed" => 253,
          "collection" => "H2JqAkscxETTtGzraycbUHGBmRVDR3PKv9cTH8ZbnA8y",
          "merkle_tree" => "DygaWE677oxFuGAto4HnqiFgnsUMAsGAnpeiE9Q8m4m1",
          "collection_bump_seed" => 254,
          "dao" => "11111111111111111111111111111111"
        })
      end

      maker_syncer = described_class.new(program_client:)
      maker_syncer.get_and_sync_maker("address")

      expect(Relay::Helium::L2::Maker.find_by(address: "address")).to have_attributes(
        update_authority: "EosEN92LercxMNWMtuSzxYCM4S7HZaLdJcEDLMKefvvS",
        issuing_authority: "4gQwHW4Sy9SGfjrNn1ALgVcHYcbBHA1p2F4NWVmoqRkN",
        name: "Kerlink",
        bump_seed: 253,
        collection: "H2JqAkscxETTtGzraycbUHGBmRVDR3PKv9cTH8ZbnA8y",
        merkle_tree: "DygaWE677oxFuGAto4HnqiFgnsUMAsGAnpeiE9Q8m4m1",
        collection_bump_seed: 254,
        dao: "11111111111111111111111111111111"
      )
    end
  end

  describe "#deserialize_and_sync_maker" do
    it "syncs the maker starting from the serialized account data" do
      program_client = instance_double(Relay::Solana::ProgramClient).tap do |client|
        allow(client).to receive(:deserialize_account).with("base64_encoded_data").and_return({
          "update_authority" => "EosEN92LercxMNWMtuSzxYCM4S7HZaLdJcEDLMKefvvS",
          "issuing_authority" => "4gQwHW4Sy9SGfjrNn1ALgVcHYcbBHA1p2F4NWVmoqRkN",
          "name" => "Kerlink",
          "bump_seed" => 253,
          "collection" => "H2JqAkscxETTtGzraycbUHGBmRVDR3PKv9cTH8ZbnA8y",
          "merkle_tree" => "DygaWE677oxFuGAto4HnqiFgnsUMAsGAnpeiE9Q8m4m1",
          "collection_bump_seed" => 254,
          "dao" => "11111111111111111111111111111111"
        })
      end

      maker_syncer = described_class.new(program_client:)
      maker_syncer.deserialize_and_sync_maker("address", "base64_encoded_data")

      expect(Relay::Helium::L2::Maker.find_by(address: "address")).to have_attributes(
        update_authority: "EosEN92LercxMNWMtuSzxYCM4S7HZaLdJcEDLMKefvvS",
        issuing_authority: "4gQwHW4Sy9SGfjrNn1ALgVcHYcbBHA1p2F4NWVmoqRkN",
        name: "Kerlink",
        bump_seed: 253,
        collection: "H2JqAkscxETTtGzraycbUHGBmRVDR3PKv9cTH8ZbnA8y",
        merkle_tree: "DygaWE677oxFuGAto4HnqiFgnsUMAsGAnpeiE9Q8m4m1",
        collection_bump_seed: 254,
        dao: "11111111111111111111111111111111"
      )
    end
  end
end
