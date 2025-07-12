# typed: strict

module Relay
  module Solana
    module Idl
      class PdaDefinition
        extend T::Sig

        sig { returns(T::Array[SeedDefinition]) }
        attr_reader :seeds

        sig { returns(T.nilable(ProgramReferenceDefinition)) }
        attr_reader :program

        class << self
          extend T::Sig

          sig { params(data: T::Hash[String, T.untyped]).returns(PdaDefinition) }
          def from_data(data)
            new(
              seeds: data.fetch("seeds").map { |seed_data| SeedDefinition.from_data(seed_data) },
              program: data["program"] ? ProgramReferenceDefinition.from_data(data["program"]) : nil,
            )
          end
        end

        sig do
          params(
            seeds: T::Array[SeedDefinition],
            program: T.nilable(ProgramReferenceDefinition)
          ).void
        end
        def initialize(seeds:, program: nil)
          @seeds = seeds
          @program = program
        end

        sig { returns(T::Hash[String, T.untyped]) }
        def as_json
          {
            seeds: seeds.map(&:as_json),
            program: program&.as_json
          }
        end
      end
    end
  end
end
