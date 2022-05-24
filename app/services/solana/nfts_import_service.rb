# frozen_string_literal: true

# Cost: 3 Credits
module Solana
  class NftsImportService < BaseService
    def initialize(wallet_address:, chain_name:)
      @wallet_address = wallet_address
      @chain_name = chain_name
    end

    def call
      import_nfts
    rescue StandardError => e
      handle_error(e.message, 'Solana::ImportNftService', e.message)
    end

    private

    attr_reader :wallet_address, :chain_name

    def import_nfts
      url = "https://api.blockchainapi.com/v1/solana/wallet/#{chain_name}/#{wallet_address}/nfts"

      handle_http_request(url: url, method: 'get', payload: nil)
    end
  end
end
