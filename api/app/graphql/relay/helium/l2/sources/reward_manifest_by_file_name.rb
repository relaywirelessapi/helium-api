# typed: strict
# frozen_string_literal: true

module Relay
  module Helium
    module L2
      module Sources
        class RewardManifestByFileName < GraphQL::Dataloader::Source
          extend T::Sig

          sig { params(keys: T::Array[String]).returns(T::Array[T.nilable(Relay::Helium::L2::RewardManifest)]) }
          def fetch(keys)
            Relay::Helium::L2::RewardManifestFile.where(file_name: keys).includes(:reward_manifest).map(&:reward_manifest)
          end
        end
      end
    end
  end
end
