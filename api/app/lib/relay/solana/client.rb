# typed: strict

module Relay
  module Solana
    class Client
      extend T::Sig

      delegate_missing_to :client

      sig { returns(SolanaRuby::HttpClient) }
      attr_reader :client

      sig { params(client: SolanaRuby::HttpClient).void }
      def initialize(client: SolanaRuby::HttpClient.new(ENV.fetch("SOLANA_RPC_URL")))
        @client = client
      end

      sig { params(program_id: String, options: T::Hash[Symbol, T.untyped]).returns(T::Array[T.untyped]) }
      def get_program_accounts(program_id, options = {})
        client.get_program_accounts(program_id, options)
      end

      sig { params(id: String).returns(T.untyped) }
      def get_asset(id)
        client.request("getAsset", { id: id }).fetch("result")
      end

      sig { params(params: T::Hash[Symbol, T.untyped]).returns(T.untyped) }
      def get_assets_by_group(params)
        client.request("getAssetsByGroup", params).fetch("result")
      end
    end
  end
end
