# typed: false

RSpec.describe Relay::Solana::ProgramClient do
  describe "#get_accounts" do
    it "fetches accounts with correct filters" do
      program = build_program_definition
      program_client = build_program_client

      result = VCR.use_cassette("program_client/get_accounts") do
        program_client.get_accounts("MakerV0")
      end

      expect(result).not_to be_empty
    end
  end

  describe "#deserialize_account" do
    it "deserializes account data correctly" do
      data = <<~BASE64.gsub("\n", "")
        YcRnkrAhR+uASMg27q/FAqfNGU27Y8tTrHSkqhR391tDK05StOuxueAvMKXYnHMOPNmNAFgBQrvT6la5B66nSBxZ/G7MqZOXBwAAAExpbnhkb3T+
        8qPMkcJRPtkCH25kmUFdaHDU1sXlAbrnIDGs69XfeQF4nSbMmTuPDSUBJm9LvxsWsgg36q20sjbgd80T589gdf+ae+IX/VId9GuOU3hocsS44WRf
        THr/J//bOAXV9VOeMwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
      BASE64

      program_client = build_program_client
      result = program_client.deserialize_account(data)

      expect(result).to eq(
        "update_authority" => "9dmZ9CW4apGzoPCo6YVkk6QKKBdoPLC2MYzQZsTywBWG",
        "issuing_authority" => "G684Spp6qzK8YxwiVDWLnpxiHVKc6jxJ4R94mGiadzxE",
        "name" => "Linxdot",
        "bump_seed" => 254,
        "collection" => "HLAXbtQBhg3SqhhA1RKi3xYfUcXFSRgkPgsthCY5mNbS",
        "merkle_tree" => "97puk7SuvRavuVNVn6p9d5kekQGf8qmPmNexuxiXY9Yx",
        "collection_bump_seed" => 255,
        "dao" => "BQ3MCuTT5zVBhNfQ4SjMh3NPVhFy73MPV8rjfq5d1zie"
      )
    end
  end

  describe "#get_and_deserialize_account" do
    it "fetches and deserializes account data" do
      program_client = build_program_client

      result = VCR.use_cassette("program_client/get_and_deserialize_account") do
        program_client.get_and_deserialize_account("BwLjgfqsGLkryn9pGV5dWcKMrDRfDVTL9H8kQLTuHUiB")
      end

      expect(result).to be_instance_of(Hash)
    end
  end

  private

  define_method(:build_program_definition) do
    Relay::Solana::Idl::ProgramDefinition.from_file(Rails.root.join("data", "idls", "helium-entity-manager.json"))
  end

  define_method(:build_program_client) do
    described_class.new(build_program_definition)
  end
end
