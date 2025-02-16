# typed: strict
# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    extend T::Sig

    field :nodes, [ Types::NodeType, null: true ], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ ID ], required: true, description: "IDs of the objects."
    end

    sig { params(ids: T::Array[String]).returns(T::Array[Types::NodeType]) }
    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    sig { params(id: String).returns(Types::NodeType) }
    def node(id:)
      context.schema.object_from_id(id, context)
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :echo, String, null: false, description: "Echoes the given message." do
      argument :message, String, required: true, description: "Message to echo"
    end

    sig { params(message: String).returns(String) }
    def echo(message:)
      message
    end

    field :status, String, null: false, description: "Retrieves the status of the API."

    sig { returns(String) }
    def status
      "ok"
    end
  end
end
