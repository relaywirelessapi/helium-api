# typed: strict

module Relay
  module Api
    module Helium
      module L2
        class HotspotBlueprint < Blueprinter::Base
          class IotInfoBlueprint < Blueprinter::Base
            field :iot_info_address, name: :address
            field :iot_bump_seed, name: :bump_seed
            field :iot_location, name: :location
            field :iot_elevation, name: :elevation
            field :iot_gain, name: :gain
            field :iot_is_full_hotspot, name: :is_full_hotspot
            field :iot_num_location_asserts, name: :num_location_asserts
            field :iot_is_active, name: :is_active
            field :iot_dc_onboarding_fee_paid, name: :dc_onboarding_fee_paid
          end

          class MobileInfoBlueprint < Blueprinter::Base
            field :mobile_info_address, name: :address
            field :mobile_bump_seed, name: :bump_seed
            field :mobile_location, name: :location
            field :mobile_is_full_hotspot, name: :is_full_hotspot
            field :mobile_num_location_asserts, name: :num_location_asserts
            field :mobile_is_active, name: :is_active
            field :mobile_dc_onboarding_fee_paid, name: :dc_onboarding_fee_paid
            field :mobile_device_type, name: :device_type
            field :mobile_antenna, name: :antenna
            field :mobile_azimuth, name: :azimuth
            field :mobile_mechanical_down_tilt, name: :mechanical_down_tilt
            field :mobile_electrical_down_tilt, name: :electrical_down_tilt
          end

          identifier :id

          field :asset_id
          field :ecc_key
          field :owner
          field :networks
          field :name
          field :maker_id

          association :iot_info, blueprint: IotInfoBlueprint do |hotspot|
            hotspot
          end

          association :mobile_info, blueprint: MobileInfoBlueprint do |hotspot|
            hotspot
          end
        end
      end
    end
  end
end
