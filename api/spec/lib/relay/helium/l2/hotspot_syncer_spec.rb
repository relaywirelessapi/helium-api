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
      it "syncs WiFi hotspots" do
        asset_id = "Eb58w6HnPcXRbZyWgSAV7g3fYFnZaoAet8qZNS3yekNL"
        maker = create(:helium_l2_maker, collection: "8Rap1SUaHABCZ18yVbubn1SQVEQHvBaiwZFeDtTn7u5a")

        VCR.use_cassette("hotspot_syncer/sync_mobile_wifi_hotspot") do
          described_class.new.sync_hotspot(asset_id)
        end

        expect(Relay::Helium::L2::Hotspot.find_by(asset_id: asset_id)).to have_attributes(
          asset_id: asset_id,
          name: "Modern Hotpink Condor",
          ecc_key: "1trSuseYprxtYN77nxFTxLexhjWSck6yVusstkFJ8bHddYzymzJT23XGY4cU2XhviFyNKTzmBF8JyySXzxjh39ovfx4CU5uCLSoPSXdXjH6HyDTv7wMgGQuTcWhfzRx2VFBZYeG9QSWLuyGdAGpbwozPvGYFUhpb3j548sXt1efQacq9DH2oU1RkHXg7vejL2vchMDHg7gvK27G2qxt4fsoVgZvZKm9ttce11pKg8666Q3eLvwBG61iCf1WenSXGZU8wPgAAyiJkfNifa5afZQa5ZCYYjijX7uLyaqgJSbdwPdtGbHPpNVZa7p3eChquxFhQvYg4BufvDFKeQrBV8CDLU8y2ErA9wzxkux7dyM4ZFQ",
          owner: "GzGPBGZ6C3UcNypFPwGBvwhpVrnci4z8u9CWgRernFJ5",
          networks: [ "mobile" ],
          maker: maker,
          mobile_info_address: "AmTbFtT34u6o72xhKQpLGSHVM2yMJLscjtkaHxLTrpvG",
          mobile_bump_seed: 253,
          mobile_location: 631210974345730047,
          mobile_is_full_hotspot: true,
          mobile_num_location_asserts: 1,
          mobile_is_active: false,
          mobile_dc_onboarding_fee_paid: 0,
          mobile_device_type: "wifi_indoor",
          mobile_antenna: 16,
          mobile_azimuth: 0,
          mobile_mechanical_down_tilt: 0,
          mobile_electrical_down_tilt: 0
        )
      end

      pending "syncs CBRS hotspots"

      it "syncs WiFi data-only hotspots" do
        asset_id = "DJx6oeStikrNaccNgNHCXLD85Neya3DgW2uNVWL6DK7o"

        VCR.use_cassette("hotspot_syncer/sync_mobile_wifi_data_only_hotspot") do
          described_class.new.sync_hotspot(asset_id)
        end

        expect(Relay::Helium::L2::Hotspot.find_by(asset_id: asset_id)).to have_attributes(
          asset_id: asset_id,
          name: "Soaring Magenta Scallop",
          ecc_key: "13r3bWVoucyyVFmw7E6DYi7ynS4QPWVYsK8W9TaKHnjA3Z5YYMP",
          owner: "fiNQ4fuWSV8f8UwWjszNiYg24EUv3wAGfTDGpJw73M8",
          networks: [ "mobile" ],
          mobile_info_address: "7nPGivJdueDq4PoBWofpP4dCxFMAzYYUKH8nxRKqAtXd",
          mobile_bump_seed: 255,
          mobile_location: 631243922688324095,
          mobile_is_full_hotspot: false,
          mobile_num_location_asserts: 1,
          mobile_is_active: false,
          mobile_dc_onboarding_fee_paid: 200000,
          mobile_device_type: "wifi_data_only",
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
