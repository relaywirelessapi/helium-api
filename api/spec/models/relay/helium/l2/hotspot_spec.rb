# typed: false

RSpec.describe Relay::Helium::L2::Hotspot do
  it "has a valid factory" do
    expect(build(:hotspot)).to be_valid
  end

  describe ".by_networks" do
    it "filters by single network" do
      create(:hotspot, networks: [ "iot" ])
      mobile_hotspot = create(:hotspot, networks: [ "mobile" ])
      dual_hotspot = create(:hotspot, networks: [ "iot", "mobile" ])

      result = described_class.by_networks([ "mobile" ])

      expect(result).to contain_exactly(mobile_hotspot, dual_hotspot)
    end

    it "filters by multiple networks" do
      iot_hotspot = create(:hotspot, networks: [ "iot" ])
      mobile_hotspot = create(:hotspot, networks: [ "mobile" ])
      dual_hotspot = create(:hotspot, networks: [ "iot", "mobile" ])

      result = described_class.by_networks([ "iot", "mobile" ])

      expect(result).to contain_exactly(iot_hotspot, mobile_hotspot, dual_hotspot)
    end
  end

  shared_examples "filters by H3 cell location" do |method_name, location_attr|
    it "filters by H3 cells at a coarser resolution" do
      parent_cell = 623386094568046591 # Resolution 7 cell
      child_cell_1 = 632393293822782975 # Resolution 12 cell within parent
      child_cell_2 = 632393293822779903 # Resolution 12 cell within parent
      outside_cell = 631608639383981055 # Resolution 12 cell outside parent
      hotspot1 = create(:hotspot, location_attr => child_cell_1)
      hotspot2 = create(:hotspot, location_attr => child_cell_2)
      create(:hotspot, location_attr => outside_cell)

      result = described_class.public_send(method_name, parent_cell)

      expect(result).to contain_exactly(hotspot1, hotspot2)
    end

    it "filters by H3 cell at the same resolution" do
      cell = 632393293822782975 # Resolution 12 cell
      outside_cell = 632393293822473727 # Different resolution 12 cell
      hotspot = create(:hotspot, location_attr => cell)
      create(:hotspot, location_attr => outside_cell)

      result = described_class.public_send(method_name, cell)

      expect(result).to contain_exactly(hotspot)
    end

    it "filters by H3 cell at a finer resolution" do
      fine_cell = 636896893450152703 # Resolution 13 cell
      parent_cell = 632393293822782463 # Its resolution 12 parent
      other_cell = 632393293823368191 # Different resolution 12 cell
      hotspot = create(:hotspot, location_attr => parent_cell)
      create(:hotspot, location_attr => other_cell)

      result = described_class.public_send(method_name, fine_cell)

      expect(result).to contain_exactly(hotspot)
    end
  end

  describe ".by_iot_location" do
    include_examples "filters by H3 cell location", :by_iot_location, :iot_location
  end

  describe ".by_mobile_location" do
    include_examples "filters by H3 cell location", :by_mobile_location, :mobile_location
  end
end
