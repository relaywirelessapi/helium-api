# typed: strict
# frozen_string_literal: true

module Relay
  module Helium
    module L2
      module Types
        class PromotionType < Relay::Types::BaseObject
          extend T::Sig

          field :entity, String, null: false, description: "The entity."
          field :start_ts, GraphQL::Types::ISO8601DateTime, null: false, description: "The start timestamp."
          field :end_ts, GraphQL::Types::ISO8601DateTime, null: false, description: "The end timestamp."
          field :shares, GraphQL::Types::BigInt, null: false, description: "The shares."
        end
      end
    end
  end
end
