# frozen_string_literal: true

# Cost: 3 Credits
module Solana
  class NftsImportService
    def initialize(wallet_address:, chain_name:)
      @wallet_address = wallet_address
      @chain_name = chain_name
    end

    def call
      import_nfts
    rescue StandardError => e
      error_msg = e.message

      Bugsnag.notify("Solana::ImportNftService ERROR - #{error_msg}") { |report| report.severity = 'error' }
      raise ActionController::BadRequest, "Error when importing NFTs: #{error_msg}"
    end

    private

    attr_reader :wallet_address, :chain_name

    def import_nfts
      url = "https://api.blockchainapi.com/v1/solana/wallet/#{chain_name}/#{wallet_address}/nfts"

      req = Faraday.new.get(url, nil, { 'content-type': 'application/json', APIKeyID: ENV['BLOCKCHAIN_API_KEY_ID'], APISecretKey: ENV['BLOCKCHAIN_SECRET_KEY'] })

      parsed_response = JSON.parse(req.body)

      return parsed_response if req.success?

      raise ActionController::BadRequest, parsed_response['error_message']
    end
  end
end
