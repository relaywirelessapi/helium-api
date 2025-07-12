# typed: false

require "sidekiq/web"

Rails.application.routes.draw do
  root "dashboard#show"

  devise_for :users, controllers: { registrations: "users/registrations" }

  scope module: :relay do
    scope module: :api, defaults: { format: :json } do
      scope path: "v1" do
        namespace :helium do
          namespace :l2 do
            resources :iot_reward_shares, only: [ :index ], path: "iot-reward-shares"
            resources :mobile_reward_shares, only: [ :index ], path: "mobile-reward-shares"
            resources :makers, only: [ :index ]
          end
        end
      end
    end
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
