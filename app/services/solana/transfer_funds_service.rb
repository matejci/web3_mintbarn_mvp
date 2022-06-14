# frozen_string_literal: true

# Cost: 2 Credits
module Solana
  class TransferFundsService < BaseService
    def initialize(nft:)
      @nft = nft
    end

    def call
      transfer_funds
    rescue StandardError => e
      handle_error(e.message, 'Solana::TransferFundsService', 'Error when transfering funds')
    end

    private

    attr_reader :nft

    def transfer_funds
      url = 'https://api.blockchainapi.com/v1/solana/wallet/transfer'

      payload = {
        recipient_address: nft.wallet_account&.address,
        wallet: {
          b58_private_key: ENV['B58_COMPANY_PRIVATE_KEY']
        },
        network: nft.chain.name.downcase,
        amount: funds_amount
      }

      handle_http_request(url: url, method: 'post', payload: payload.to_json)
    end

    def funds_amount
      format('%.9f', nft.price_in_lamports * SOLS_IN_LAMPORT)
    end
  end
end
