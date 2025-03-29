# typed: false

RSpec.describe Relay::Plan do
  describe ".all" do
    it "returns an array of plans" do
      plans = described_class.all
      expect(plans).to be_an(Array)
      expect(plans).not_to be_empty
      expect(plans.first).to be_a(described_class)
    end
  end
end
