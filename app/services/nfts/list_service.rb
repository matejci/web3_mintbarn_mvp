# frozen_string_literal: true

module Nfts
  class ListService
    def initialize(nft:, wallet_address:, chain_name:, price:)
      @nft = nft
      @wallet_address = wallet_address
      @chain_name = chain_name
      @price = price
    end

    def call
      validate_listing
      list_nft
    rescue StandardError => e
      error_msg = e.message
      Bugsnag.notify("NFTS::ListService ERROR - #{error_msg}") { |report| report.severity = 'error' }
      raise ActionController::BadRequest, error_msg
    end

    private

    attr_reader :nft, :wallet_address, :chain_name, :price

    def validate_listing
      raise ActionController::BadRequest, 'You are not allowed to list this NFT' unless nft.wallet_account.address == wallet_address
    end

    def list_nft
      company_transfer
    end

    def company_transfer
      transfer = Solana::TransferWithSignatureService.new(recipient: ENV['COMPANY_PUBLIC_KEY'],
                                                          token_address: nft.mint_address,
                                                          chain_name: chain_name,
                                                          wallet_address: wallet_address).call

      nft.update!(compiled_transaction: transfer, status: :waiting_for_signature)
      transfer
    end
  end
end
