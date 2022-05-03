# frozen_string_literal: true

# Cost: 2 Credits
module Solana
  class TransferNftService
    def initialize(recipient:, token_address:, chain_name:)
      @recipient = recipient
      @token_address = token_address
      @chain_name = chain_name
    end

    def call
      transfer_nft
    rescue StandardError => e
      error_msg = e.message

      Bugsnag.notify("Solana::TransferNftService ERROR - #{error_msg}") { |report| report.severity = 'error' }
      raise ActionController::BadRequest, "Error when transfering NFT: #{error_msg}"
    end

    private

    attr_reader :recipient, :token_address, :chain_name

    def transfer_nft
      url = 'https://api.blockchainapi.com/v1/solana/wallet/transfer'

      payload = {
        recipient_address: recipient,
        wallet: {
          b58_private_key: ENV['B58_COMPANY_PRIVATE_KEY']
        },
        token_address: token_address,
        network: chain_name,
        amount: '1' # value for NFTs
      }

      req = Faraday.new.post(url, payload.to_json, { 'content-type': 'application/json', APIKeyID: ENV['BLOCKCHAIN_API_KEY_ID'], APISecretKey: ENV['BLOCKCHAIN_SECRET_KEY'] })

      parsed_response = JSON.parse(req.body)

      return parsed_response if req.success?

      raise ActionController::BadRequest, parsed_response['error_message']
    end
  end
end
