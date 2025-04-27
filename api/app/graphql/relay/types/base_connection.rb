# typed: strict
# frozen_string_literal: true

module Relay
  module Types
    class BaseConnection < Types::BaseObject
      include GraphQL::Types::Relay::ConnectionBehaviors
    end
  end
end
