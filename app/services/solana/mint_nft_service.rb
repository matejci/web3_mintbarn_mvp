# frozen_string_literal: true

# Cost: 5 Credits
module Solana
  class MintNftService
    def initialize(local_nft:, metadata_url:, chain_name:)
      @local_nft = local_nft
      @metadata_url = metadata_url
      @chain_name = chain_name
    end

    def call
      mint_nft
    rescue StandardError => e
      error_msg = e.message

      Bugsnag.notify("Solana::MintNftService ERROR - #{error_msg}") { |report| report.severity = 'error' }
      raise ActionController::BadRequest, "Error when minting NFT: #{error_msg}"
    end

    private

    attr_reader :local_nft, :metadata_url, :chain_name

    def mint_nft
      url = 'https://api.blockchainapi.com/v1/solana/nft'

      payload = {
        wallet: {
          b58_private_key: ENV['B58_COMPANY_PRIVATE_KEY']
        },
        nft_name: local_nft.name,
        nft_symbol: local_nft.symbol,
        nft_url: metadata_url,
        nft_upload_method: 'LINK',
        is_mutable: local_nft.is_mutable,
        is_master_edition: local_nft.is_master_edition,
        seller_fee_basis_points: local_nft.seller_fee_basis_points,
        creators: local_nft.creators,
        share: local_nft.share.map(&:to_i),
        mint_to_public_key: ENV['COMPANY_PUBLIC_KEY'],
        network: chain_name
      }

      req = Faraday.new.post(url, payload.to_json, { 'content-type': 'application/json', APIKeyID: ENV['BLOCKCHAIN_API_KEY_ID'], APISecretKey: ENV['BLOCKCHAIN_SECRET_KEY'] })

      parsed_response = JSON.parse(req.body)

      return parsed_response if req.success?

      raise ActionController::BadRequest, parsed_response['error_message']
    end
  end
end
