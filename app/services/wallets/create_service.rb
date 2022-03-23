# frozen_string_literal: true

module Wallets
  class CreateService
    def initialize(address:, chain:, wallet_name:, account_name:)
      @address = address
      @chain = chain
      @wallet_name = wallet_name
      @account_name = account_name.presence || nil
    end

    def call
      validate_params
      create_wallet
    end

    private

    attr_reader :address, :chain, :wallet_name, :account_name

    def validate_params
      raise ActionController::BadRequest, 'Missing request header' unless address.present? && chain.present?
      raise ActionController::BadRequest, 'Missing params' if wallet_name.blank?
    end

    def create_wallet
      network_chain = Chain.where('name ILIKE ?', chain).first

      raise ActionController::BadRequest, 'Wallet chain can not be found' unless chain

      wa = WalletAccount.find_or_create_by(wallet_name: wallet_name, address: address)
      wa.update(account_name: account_name) if account_name
      wa.chains << network_chain
      wa.id
    end
  end
end
