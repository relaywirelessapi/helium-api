# typed: strict
# frozen_string_literal: true

module Relay
  module Types
    module NodeType
      include Types::BaseInterface
      include GraphQL::Types::Relay::NodeBehaviors
    end
  end
end
