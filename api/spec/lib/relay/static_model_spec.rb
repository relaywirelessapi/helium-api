# typed: false

RSpec.describe Relay::StaticModel do
  class TestStaticModel < Relay::StaticModel
    self.define_singleton_method(:all) do
      [
        new(id: "1"),
        new(id: "2"),
        new(id: "3")
      ]
    end
  end

  describe ".find" do
    it "returns nil when no matching record is found" do
      expect(TestStaticModel.find("nonexistent")).to be_nil
    end

    it "returns the matching record when found" do
      expect(TestStaticModel.find("1")).to have_attributes(id: "1")
    end
  end

  describe ".find_by_id" do
    it "is an alias for find" do
      expect(TestStaticModel.find_by_id("1")).to have_attributes(id: "1")
    end
  end

  describe ".find!" do
    it "returns the matching record when found" do
      expect(TestStaticModel.find!("1")).to have_attributes(id: "1")
    end

    it "raises ArgumentError when no matching record is found" do
      expect { TestStaticModel.find!("nonexistent") }.to raise_error(ArgumentError)
    end
  end
end
