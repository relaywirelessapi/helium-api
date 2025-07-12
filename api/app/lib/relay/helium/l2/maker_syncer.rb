# typed: strict

module Relay
  module Helium
    module L2
      class MakerSyncer
        extend T::Sig

        HEM_IDL_PATH = T.let(Rails.root.join("data", "idls", "helium-entity-manager.json"), Pathname)

        sig { returns(Relay::Solana::ProgramClient) }
        attr_reader :program_client

        sig { params(program_client: Relay::Solana::ProgramClient).void }
        def initialize(program_client: Relay::Solana::ProgramClient.new(Relay::Solana::Idl::ProgramDefinition.from_file(HEM_IDL_PATH)))
          @program_client = program_client
        end

        sig { returns(T::Array[T::Hash[String, T.untyped]]) }
        def list_makers
          program_client.get_accounts("MakerV0")
        end

        sig { params(address: String, data: T::Hash[String, T.untyped]).void }
        def sync_maker(address, data)
          maker = Relay::Helium::L2::Maker.find_or_initialize_by(address: address)

          maker.update_authority = data.fetch("update_authority")
          maker.issuing_authority = data.fetch("issuing_authority")
          maker.name = data.fetch("name")
          maker.bump_seed = data.fetch("bump_seed")
          maker.collection = data.fetch("collection")
          maker.merkle_tree = data.fetch("merkle_tree")
          maker.collection_bump_seed = data.fetch("collection_bump_seed")
          maker.dao = data.fetch("dao")

          maker.save!
        end

        sig { params(address: String).void }
        def get_and_sync_maker(address)
          data = program_client.get_and_deserialize_account(address)
          sync_maker(address, data)
        end

        sig { params(address: String, data: String).void }
        def deserialize_and_sync_maker(address, data)
          deserialized_data = program_client.deserialize_account(data)
          sync_maker(address, deserialized_data)
        end
      end
    end
  end
end
