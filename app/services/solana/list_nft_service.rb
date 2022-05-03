# frozen_string_literal: true

# Cost: 12 Credits, 3 Credits on Devnet
module Solana
  class ListNftService
    EXCHANGES = %w[solsea magic-eden].freeze

    def initialize(chain_name:, mint_address:, price:)
      @chain_name = chain_name
      @mint_address = mint_address
      @price = price
    end

    def call
      list_nft
    rescue StandardError => e
      error_msg = e.message

      Bugsnag.notify("Solana::ListNftService ERROR - #{error_msg}") { |report| report.severity = 'error' }
      raise ActionController::BadRequest, "Error when listing NFT: #{error_msg}"
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

      req = Faraday.new.post(url, payload.to_json, { 'content-type': 'application/json', APIKeyID: ENV['BLOCKCHAIN_API_KEY_ID'], APISecretKey: ENV['BLOCKCHAIN_SECRET_KEY'] })

      parsed_response = JSON.parse(req.body)

      return parsed_response if req.success?

      raise ActionController::BadRequest, parsed_response['error_message']
    end
  end
end
