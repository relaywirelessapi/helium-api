# typed: strict
# frozen_string_literal: true

module Types
  class RewardDataType < Types::BaseUnion
    description "Represents either mobile or IoT reward data"
    possible_types Types::MobileRewardDataType, Types::IotRewardDataType

    class << self
      extend T::Sig

      sig do
        params(
          object: T::Hash[String, T.untyped],
          context: GraphQL::Query::Context
        ).returns(T.any(
          T.class_of(Types::MobileRewardDataType),
          T.class_of(Types::IotRewardDataType)
        ))
      end

      def resolve_type(object, context)
        case object["reward_type"]
        when "mobile"
          Types::MobileRewardDataType
        when "iot"
          Types::IotRewardDataType
        else
          raise "Unexpected reward type: #{object["reward_type"]}"
        end
      end
    end
  end
end
