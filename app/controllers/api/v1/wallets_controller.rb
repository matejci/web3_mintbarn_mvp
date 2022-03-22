# frozen_string_literal: true

module Api
  module V1
    class WalletsController < BaseController
      skip_before_action :set_current_wallet_account

      def create
        Wallets::CreateService.new(address: request.headers['WALLET-ADDRESS'],
                                   chain: request.headers['WALLET-CHAIN'],
                                   wallet_name: params[:wallet_name],
                                   account_name: params[:account_name]).call

        head :created
      end
    end
  end
end
