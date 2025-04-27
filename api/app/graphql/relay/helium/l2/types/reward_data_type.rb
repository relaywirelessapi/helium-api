# typed: strict
# frozen_string_literal: true

module Relay
  module Helium
    module L2
      module Types
        class RewardDataType < Relay::Types::BaseUnion
          description "Represents either mobile or IoT reward data"
          possible_types MobileRewardDataType, IotRewardDataType

          class << self
            extend T::Sig

            sig do
              params(
                object: T::Hash[String, T.untyped],
                context: GraphQL::Query::Context
              ).returns(T.any(
                T.class_of(MobileRewardDataType),
                T.class_of(IotRewardDataType)
              ))
            end
            def resolve_type(object, context)
              case object["reward_type"]
              when "mobile"
                MobileRewardDataType
              when "iot"
                IotRewardDataType
              else
                raise "Unexpected reward type: #{object["reward_type"]}"
              end
            end
          end
        end
      end
    end
  end
end
