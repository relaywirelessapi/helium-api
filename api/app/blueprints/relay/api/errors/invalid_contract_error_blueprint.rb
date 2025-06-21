# typed: strict

module Relay
  module Api
    module Errors
      class InvalidContractErrorBlueprint < Blueprinter::Base
        field :errors do |object|
          object.contract.errors.map do |error|
            {
              param: error.attribute,
              message: error.message
            }
          end
        end
      end
    end
  end
end
