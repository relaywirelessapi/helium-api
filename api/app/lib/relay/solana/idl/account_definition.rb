# typed: strict

module Relay
  module Solana
    module Idl
      class AccountDefinition
        extend T::Sig

        sig { returns(String) }
        attr_reader :name

        sig { returns(T::Array[Integer]) }
        attr_reader :discriminator

        class << self
          extend T::Sig

          sig { params(data: T::Hash[String, T.untyped]).returns(AccountDefinition) }
          def from_data(data)
            new(
              name: data.fetch("name"),
              discriminator: data.fetch("discriminator"),
            )
          end
        end

        class InvalidDiscriminatorError < StandardError; end

        sig { params(name: String, discriminator: T::Array[Integer]).void }
        def initialize(name:, discriminator:)
          @name = name
          @discriminator = discriminator
        end

        sig { params(account_data: String).returns(T::Boolean) }
        def valid_discriminator?(account_data)
          actual_discriminator = T.cast(
            T.cast(account_data[0, 8], String).unpack("C*"),
            T::Array[Integer]
          )

          discriminator == actual_discriminator
        end

        sig { params(account_data: String).void }
        def validate_discriminator!(account_data)
          return if valid_discriminator?(account_data)

          raise InvalidDiscriminatorError, "Invalid account discriminator"
        end
      end
    end
  end
end
