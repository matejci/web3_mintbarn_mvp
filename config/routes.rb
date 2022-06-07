# frozen_string_literal: true

require 'api_constraints'
require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web, at: '/sidekiq'
  # mount ActionCable.server => '/chatroom'

  if Rails.env.production?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV.fetch('SIDEKIQ_USERNAME', 'nftadmin'))) &
        ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV('SIDEKIQ_PASSWORD', 'mynfts123!')))
    end
  end

  root 'home#index'

  namespace :api, path: '', defaults: { format: 'json' } do
    scope module: 'v1', constraints: ApiConstraints.new(version: 1) do
      resources :sessions, only: :create

      resources :users, only: :none do
        get :profile, on: :collection
      end

      resources :wallets, only: :create
      resources :nfts, only: [:create, :show, :index] do
        member do
          post :list
        end
      end

      resources :solana_tokens, only: :index
    end

    # scope module: 'v2', constraints: ApiConstraints.new(version: 2) do
    #   resources :sessions
    # end
  end

  resources :nfts, only: :show

  # apple universal links
  get '/apple-app-site-association', to: 'home#aasa'
  get '/.well-known/apple-app-site-association', to: 'home#aasa'

  get '/terms', to: 'home#terms'
end
