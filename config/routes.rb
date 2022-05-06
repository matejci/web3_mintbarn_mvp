# frozen_string_literal: true

require 'api_constraints'

Rails.application.routes.draw do
  root 'home#index'

  namespace :api, path: '', defaults: { format: 'json' } do
    scope module: 'v1', constraints: ApiConstraints.new(version: 1) do
      resources :sessions, only: :create

      resources :users, only: :none do
        get :profile, on: :collection
      end

      resources :wallets, only: :create
      resources :nfts, only: [:create, :show, :index]

      resources :solana_tokens, only: :index
    end

    # scope module: 'v2', constraints: ApiConstraints.new(version: 2) do
    #   resources :sessions
    # end
  end

  # apple universal links
  get '/apple-app-site-association', to: 'home#aasa'
  get '/.well-known/apple-app-site-association', to: 'home#aasa'
end
