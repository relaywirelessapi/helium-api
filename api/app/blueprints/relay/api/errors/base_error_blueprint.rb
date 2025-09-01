# typed: strict

module Relay
  module Api
    module Errors
      class BaseErrorBlueprint < Blueprinter::Base
        field :code
        field :message
      end
    end
  end
end
