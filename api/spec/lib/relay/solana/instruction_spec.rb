# typed: false

RSpec.describe Relay::Solana::Instruction do
  describe ".from_rpc" do
    it "decodes the instruction properly" do
      instruction = JSON.parse(File.read(Rails.root.join("spec/fixtures/helius-webhook.json"))).first.fetch("transaction").fetch("message").fetch("instructions").last

      instruction = described_class.from_rpc(instruction)

      expect(instruction).to have_attributes(
        program_index: 19,
        account_indices: [ 0, 0, 2, 0, 11, 10, 1, 7, 14, 8, 3, 18, 13, 15, 17, 20, 12, 4, 9, 5, 6 ],
        data: "5uy6njmBG1vs3N5kjSEEZYVWQPqAe4JuzCNKU1RXRXe7HUEu9h6R6posxHn6ZVatTzsJNMo9RGwAqQPyZFuZQ5Dn37Rb7xQ24H8wqSGTBdqn4AEroS927eiHvacBLDQfWbh3ZytbK1XEE1H8jSUAMmcj4WShKbTH527fJPBHR4cJqM",
      )
    end
  end
end
