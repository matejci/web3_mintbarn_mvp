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
      wallet = create_wallet
      assign_chains(wallet)
      # TODO, assign subscription plan/credits etc
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

      WalletAccount.create!(create_attrs)
    end

    def assign_chains(wallet)
      Chain.all.each { |chain| wallet.chains << chain }
    end
  end
end
