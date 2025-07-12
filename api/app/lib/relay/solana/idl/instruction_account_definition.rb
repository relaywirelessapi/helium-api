# typed: strict

module Relay
  module Solana
    module Idl
      class InstructionAccountDefinition
        extend T::Sig

        sig { returns(String) }
        attr_reader :name

        sig { returns(T::Boolean) }
        attr_reader :writable

        sig { returns(T::Boolean) }
        attr_reader :signer

        sig { returns(T::Boolean) }
        attr_reader :optional

        sig { returns(T.nilable(PdaDefinition)) }
        attr_reader :pda

        sig { returns(T::Array[String]) }
        attr_reader :relations

        sig { returns(T.nilable(String)) }
        attr_reader :address

        class << self
          extend T::Sig

          sig { params(data: T::Hash[String, T.untyped]).returns(InstructionAccountDefinition) }
          def from_data(data)
            new(
              name: data.fetch("name"),
              writable: data.fetch("writable", false),
              signer: data.fetch("signer", false),
              optional: data.fetch("optional", false),
              pda: data["pda"] ? PdaDefinition.from_data(data["pda"]) : nil,
              relations: data.fetch("relations", []),
              address: data["address"],
            )
          end
        end

        sig do
          params(
            name: String,
            writable: T::Boolean,
            signer: T::Boolean,
            optional: T::Boolean,
            pda: T.nilable(PdaDefinition),
            relations: T::Array[String],
            address: T.nilable(String)
          ).void
        end
        def initialize(name:, writable: false, signer: false, optional: false, pda: nil, relations: [], address: nil)
          @name = name
          @writable = writable
          @signer = signer
          @optional = optional
          @pda = pda
          @relations = relations
          @address = address
        end
      end
    end
  end
end
