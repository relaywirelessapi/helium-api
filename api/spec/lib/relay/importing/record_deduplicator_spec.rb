# typed: false

RSpec.describe Relay::Importing::RecordDeduplicator do
  describe "#calculate_deduplication_key" do
    it "returns a deduplication key for a row" do
      deduplicator = described_class.new
      key = deduplicator.calculate_deduplication_key({ name: "Item 1" })

      expect(key).to eq("38ad63afcd7c0a2f60cb204f65635fd9")
    end

    it "converts binary data to Base64" do
      deduplicator = described_class.new
      key = deduplicator.calculate_deduplication_key({ name: "Item 1", data: "\x00\x01\x02\x03".force_encoding("ASCII-8BIT") })

      expect(key).to eq("9c9de280167b91e04d9ef7c25817ea6a")
    end
  end
end
