# typed: false

require "sidekiq/web"

Rails.application.routes.draw do
  root "dashboard#show"

  devise_for :users, controllers: { registrations: "users/registrations" }

  post "/graphql", to: "graphql#execute"
  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"

  JSON.parse(File.read(Rails.root.join("config", "data", "persisted-queries.json"))).each_key do |query_id|
    get "/graphql/#{query_id}", to: "graphql#execute_persisted_query", query_id: query_id, as: "#{query_id.parameterize(separator: '_')}_graphql_query"
  end

  get "up" => "rails/health#show", as: :rails_health_check

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(
      ::Digest::SHA256.hexdigest(username),
      ::Digest::SHA256.hexdigest(ENV.fetch("SIDEKIQ_USERNAME"))
    ) & ActiveSupport::SecurityUtils.secure_compare(
      ::Digest::SHA256.hexdigest(password),
      ::Digest::SHA256.hexdigest(ENV.fetch("SIDEKIQ_PASSWORD"))
    )
  end
  mount Sidekiq::Web => "/sidekiq"
end
