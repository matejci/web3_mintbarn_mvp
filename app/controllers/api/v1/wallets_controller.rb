# frozen_string_literal: true

module Api
  module V1
    class WalletsController < BaseController
      skip_before_action :set_current_wallet_account, :set_current_chain
      before_action :check_wallet_address

      def create
        Wallets::CreateService.new(address: request.headers['WALLET-ADDRESS'],
                                   wallet_name: params[:wallet_name],
                                   account_name: params[:account_name]).call

        head :created
      end

      private

      def check_wallet_address
        raise ActionController::BadRequest, 'Invalid wallet address' unless Minerstat::WalletAddressValidatorService.new(address: request.headers['WALLET-ADDRESS']).call
      end
    end
  end
end
