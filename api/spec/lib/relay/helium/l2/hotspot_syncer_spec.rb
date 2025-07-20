# typed: false

RSpec.describe Relay::Helium::L2::HotspotSyncer, :aggregate_failures do
  describe "#list_hotspots_for_maker" do
    it "returns the list of hotspots for the maker" do
      maker = create(:helium_l2_maker, collection: "9JpM1VAnjhaPWNFf5iVD8CJWAwpV9ebKGyNoUBmcTWtC")

      hotspots = VCR.use_cassette("hotspot_syncer/list_hotspots_for_maker") do
        described_class.new.list_hotspots_for_maker(maker).to_a
      end

      expect(hotspots).to be_instance_of(Array)
    end
  end

  describe "#sync_hotspot" do
    context "with Mobile hotspots" do
      it "syncs Mobile information" do
        asset_id = "8xuTGix1jPvt9vRrtiQdCXSLVkoK7zJ3QmkYvM4j8wbY"
        maker = create(:helium_l2_maker, collection: "9JpM1VAnjhaPWNFf5iVD8CJWAwpV9ebKGyNoUBmcTWtC")

        VCR.use_cassette("hotspot_syncer/sync_mobile_hotspot") do
          described_class.new.sync_hotspot(asset_id)
        end

        expect(Relay::Helium::L2::Hotspot.find_by(asset_id: asset_id)).to have_attributes(
          asset_id: asset_id,
          name: "Zany Sapphire Tarantula",
          ecc_key: "112gc4K2Z5GndZYKyWiWBh8HXrVT31QKULcCn8fsSuoncySdTEsE",
          owner: "2ies7cf1oXPB9fMcdzmmydTXKyhnCXWSaB5sPWi5FYKw",
          networks: [ "mobile" ],
          maker: maker,
          mobile_info_address: "6vuUgMCvRiuu6cd7ng7DMbigvcSfCRe1krYVxJvQYENm",
          mobile_bump_seed: 254,
          mobile_location: 631713450899951103,
          mobile_is_full_hotspot: true,
          mobile_num_location_asserts: 1,
          mobile_is_active: false,
          mobile_dc_onboarding_fee_paid: 4000000,
          mobile_device_type: "cbrs",
          mobile_antenna: nil,
          mobile_azimuth: nil,
          mobile_mechanical_down_tilt: nil,
          mobile_electrical_down_tilt: nil
        )
      end
    end

    context "with IoT hotspots" do
      it "syncs IoT information" do
        asset_id = "Hpf4i2K7QqoToQev2V9KbMahCHpNhzjVKPYUQxNNas1w"
        maker = create(:helium_l2_maker, collection: "FC2daoG1bnBPHGBypxPLb8hU8dtQdx7cYYsU9RR4eYmf")

        VCR.use_cassette("hotspot_syncer/sync_iot_hotspot") do
          described_class.new.sync_hotspot(asset_id)
        end

        expect(Relay::Helium::L2::Hotspot.find_by(asset_id: asset_id)).to have_attributes(
          asset_id: asset_id,
          name: "Creamy Lavender Alligator",
          ecc_key: "11vBaUqP9vfN8qRkMSwVkQqPdGraJCzWxQdX4cbq89WqkTZtpVF",
          owner: "AoKabrzG8tPdPvrn6jNLwP4tiwzpBrTuT6gz1SV6EQCR",
          networks: [ "iot" ],
          maker: maker,
          iot_info_address: "2dwqoCEmrQZG8VUuSB5RRvfe5WPf6ibn1PKRxc7Gf7m7",
          iot_bump_seed: 254,
          iot_location: 631254393077979135,
          iot_elevation: 10,
          iot_gain: 23,
          iot_is_full_hotspot: true,
          iot_num_location_asserts: 7,
          iot_is_active: false,
          iot_dc_onboarding_fee_paid: 4000000,
        )
      end
    end
  end
end
