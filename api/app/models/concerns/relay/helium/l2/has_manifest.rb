# typed: false

module Relay
  module Helium
    module L2
      module HasManifest
        extend ActiveSupport::Concern

        included do
          belongs_to(
            :reward_manifest_file,
            class_name: "Helium::L2::RewardManifestFile",
            foreign_key: :file_name,
            primary_key: :file_name,
            inverse_of: false,
            optional: true
          )

          has_one(
            :reward_manifest,
            through: :reward_manifest_file,
            source: :reward_manifest
          )
        end
      end
    end
  end
end
