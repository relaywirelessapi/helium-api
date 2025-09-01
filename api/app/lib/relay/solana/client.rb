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

      sig { params(address: String).returns(T.untyped) }
      def get_parsed_account_info(address)
        client.get_parsed_account_info(address)
      end

      sig { params(params: T::Hash[Symbol, T.untyped]).returns(T.untyped) }
      def get_asset(params)
        client.request("getAsset", params).fetch("result")
      end

      sig { params(params: T::Hash[Symbol, T.untyped]).returns(T::Enumerator[T.untyped]) }
      def get_assets_by_group(params)
        Enumerator.new do |yielder|
          page = 1

          loop do
            response = client.request("getAssetsByGroup", params.merge(page: page))
            items = response.fetch("result").fetch("items", [])

            break if items.empty?

            items.each { |item| yielder << item }
            page += 1
          end
        end
      end
    end
  end
end
