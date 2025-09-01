# typed: strict

module Relay
  module Helium
    module L2
      class HotspotSyncer
        extend T::Sig

        HEM_IDL_PATH = T.let(Rails.root.join("data", "idls", "helium-entity-manager.json"), Pathname)

        sig { returns(Relay::Solana::Client) }
        attr_reader :client

        sig { returns(Relay::Solana::ProgramClient) }
        attr_reader :program_client

        sig { params(client: Relay::Solana::Client, program_client: Relay::Solana::ProgramClient).void }
        def initialize(
          client: Relay::Solana::Client.new,
          program_client: Relay::Solana::ProgramClient.new(Relay::Solana::Idl::ProgramDefinition.from_file(HEM_IDL_PATH))
        )
          @client = client
          @program_client = program_client
        end

        sig { params(maker: Maker).returns(T::Enumerator[T::Hash[String, T.untyped]]) }
        def list_hotspots_for_maker(maker)
          client.get_assets_by_group(groupKey: "collection", groupValue: maker.collection)
        end

        sig { params(asset_id: String).void }
        def sync_hotspot(asset_id)
          asset = client.get_asset({ id: asset_id })
          data = JSON.parse(HTTParty.get(asset.fetch("content").fetch("json_uri")).body)

          hotspot = Relay::Helium::L2::Hotspot.find_or_initialize_by(asset_id: asset_id)

          hotspot.networks = data.fetch("attributes", {}).find do |attribute|
            attribute.fetch("trait_type") == "networks"
          end.fetch("value")
          hotspot.owner = asset.fetch("ownership").fetch("owner")
          hotspot.name = data.fetch("name")
          hotspot.ecc_key = data.fetch("entity_key_str")
          hotspot.maker = Maker.find_by(collection: asset.fetch("grouping").find do |grouping|
            grouping.fetch("group_key") == "collection"
          end.fetch("group_value"))

          hotspot.iot_info_address = data.fetch("hotspot_infos").dig("iot", "address")
          hotspot.mobile_info_address = data.fetch("hotspot_infos").dig("mobile", "address")

          if hotspot.iot_info_address.present?
            iot_info = program_client.get_and_deserialize_account(T.must(hotspot.iot_info_address))
            hotspot.iot_bump_seed = iot_info.fetch("bump_seed")
            hotspot.iot_location = iot_info.fetch("location")
            hotspot.iot_elevation = iot_info.fetch("elevation")
            hotspot.iot_gain = iot_info.fetch("gain")
            hotspot.iot_is_full_hotspot = iot_info.fetch("is_full_hotspot")
            hotspot.iot_num_location_asserts = iot_info.fetch("num_location_asserts")
            hotspot.iot_is_active = iot_info.fetch("is_active")
            hotspot.iot_dc_onboarding_fee_paid = iot_info.fetch("dc_onboarding_fee_paid")
          end

          if hotspot.mobile_info_address.present?
            mobile_info = program_client.get_and_deserialize_account(T.must(hotspot.mobile_info_address))

            hotspot.mobile_bump_seed = mobile_info.fetch("bump_seed")
            hotspot.mobile_location = mobile_info.fetch("location")
            hotspot.mobile_is_full_hotspot = mobile_info.fetch("is_full_hotspot")
            hotspot.mobile_num_location_asserts = mobile_info.fetch("num_location_asserts")
            hotspot.mobile_is_active = mobile_info.fetch("is_active")
            hotspot.mobile_dc_onboarding_fee_paid = mobile_info.fetch("dc_onboarding_fee_paid")
            hotspot.mobile_device_type = mobile_info.fetch("device_type").fetch(:variant).to_s.underscore

            if (deployment_info = mobile_info.fetch("deployment_info"))
              case deployment_info.fetch(:variant)
              when "WifiInfoV0"
                data = deployment_info.fetch(:data)
                hotspot.mobile_antenna = data.fetch("antenna")
                hotspot.mobile_azimuth = data.fetch("azimuth")
                hotspot.mobile_mechanical_down_tilt = data.fetch("mechanical_down_tilt")
                hotspot.mobile_electrical_down_tilt = data.fetch("electrical_down_tilt")
              when "CbrsInfoV0"
                hotspot.radios.destroy_all
                deployment_info.fetch(:data).fetch("radio_infos", []).each do |radio_info|
                  hotspot.radios.build(
                    radio_id: radio_info.fetch("radio_id"),
                    elevation: radio_info.fetch("elevation")
                  )
                end
              end
            end
          end

          hotspot.save!
          hotspot.radios.each(&:save!)
        end
      end
    end
  end
end
