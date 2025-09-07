# typed: strict

module Relay
  module Helium
    module L2
      class RewardManifestFile < ApplicationRecord
        extend T::Sig

        self.table_name = "helium_l2_reward_manifest_files"
        self.primary_key = [ "reward_manifest_id", "file_name" ]

        belongs_to(
          :reward_manifest,
          class_name: "Relay::Helium::L2::RewardManifest",
          inverse_of: :files
        )

        after_create_commit :schedule_mobile_offload_calculations

        class << self
          extend T::Sig

          sig { params(global_id: T.untyped).returns(T.nilable(Relay::Helium::L2::RewardManifestFile)) }
          def find_by_global_id(global_id)
            return nil unless global_id.respond_to?(:model_id)

            reward_manifest_id, file_name = global_id.model_id.split("-", 2)
            find_by(reward_manifest_id: reward_manifest_id, file_name: file_name)
          end
        end

        sig { params(options: T.untyped).returns(GlobalID) }
        def to_global_id(options = {})
          GlobalID.new("gid://helium-api/Relay::Helium::L2::RewardManifestFile/#{reward_manifest_id}-#{file_name}", options)
        end

        private

        sig { void }
        def schedule_mobile_offload_calculations
          Relay::Helium::L2::ScheduleMobileOffloadCalculationsJob.perform_later(self)
        end
      end
    end
  end
end
