# typed: false

require "graphql/rake_task"
GraphQL::RakeTask.new(schema_name: "Relay::ApplicationSchema")
