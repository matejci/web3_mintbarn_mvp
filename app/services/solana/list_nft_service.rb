# frozen_string_literal: true

# Cost: 12 Credits, 3 Credits on Devnet
module Solana
  class ListNftService < BaseService
    EXCHANGES = %w[solsea magic-eden].freeze

    def initialize(chain_name:, mint_address:, price:)
      @chain_name = chain_name
      @mint_address = mint_address
      @price = price
    end

    def call
      list_nft
    rescue StandardError => e
      handle_error(e.message, 'Solana::ListNftService', e.message)
    end

    private

    attr_reader :chain_name, :mint_address, :price

    def list_nft
      url = "https://api.blockchainapi.com/v1/solana/nft/marketplaces/#{EXCHANGES.last}/list/#{chain_name}/#{mint_address}"

      payload = {
        wallet: {
          b58_private_key: ENV['B58_COMPANY_PRIVATE_KEY']
        },
        nft_price: price
      }

      handle_http_request(url: url, method: 'post', payload: payload.to_json)
    end
  end
end
