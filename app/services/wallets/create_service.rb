# frozen_string_literal: true

module Wallets
  class CreateService
    def initialize(address:, wallet_name:, account_name:)
      @address = address
      @wallet_name = wallet_name
      @account_name = account_name.presence || nil
    end

    def call
      validate_params
      create_wallet
    end

    private

    attr_reader :address, :wallet_name, :account_name

    def validate_params
      raise ActionController::BadRequest, 'Missing request header' if address.blank?
      raise ActionController::BadRequest, 'Missing params' if wallet_name.blank?
    end

    def create_wallet
      create_attrs = {
        wallet_name: wallet_name,
        address: address
      }

      create_attrs[:account_name] = account_name if account_name

      wa = WalletAccount.create!(create_attrs)

      Chain.all.each do |chain|
        wa.chains << chain
      end
    end
  end
end
