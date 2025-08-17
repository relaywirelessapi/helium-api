# typed: false

require "sidekiq/web"

Rails.application.routes.draw do
  root "dashboard#show"

  devise_for :users, controllers: { registrations: "users/registrations" }

  scope module: :relay do
    scope module: :api, defaults: { format: :json } do
      scope path: "v1" do
        namespace :helium do
          namespace :l1 do
            resources :accounts, only: [ :index ]
          end

          namespace :l2 do
            resources :iot_reward_shares, only: [ :index ], path: "iot-reward-shares" do
              collection do
                get :totals
              end
            end
            resources :mobile_reward_shares, only: [ :index ], path: "mobile-reward-shares" do
              collection do
                get :totals
              end
            end
            resources :makers, only: [ :index ]
            resources :hotspots, only: [ :index ]
          end
        end
      end
    end

    namespace :webhooks do
      post "helius" => "webhooks#create", source: "helius"
      post "stripe" => "webhooks#create", source: "stripe"
    end
  end

  get "/billing" => "dashboard#billing_portal", as: :billing_portal
  post "/subscribe/:plan_id" => "dashboard#subscribe", as: :subscribe

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
