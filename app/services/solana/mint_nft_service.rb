# frozen_string_literal: true

# Cost: 5 Credits
module Solana
  class MintNftService < BaseService
    def initialize(local_nft:, chain_name:)
      @local_nft = local_nft
      @chain_name = chain_name
    end

    def call
      mint_nft
    rescue StandardError => e
      handle_error(e.message, 'Solana::MintNftService', e.message)
    end

    private

    attr_reader :local_nft, :chain_name

    def mint_nft
      url = 'https://api.blockchainapi.com/v1/solana/nft'

      payload = {
        wallet: {
          b58_private_key: ENV['B58_COMPANY_PRIVATE_KEY']
        },
        nft_name: local_nft.name,
        nft_symbol: local_nft.symbol,
        uri: local_nft.metadata_url,
        upload_method: 'URI',
        is_mutable: local_nft.is_mutable,
        is_master_edition: local_nft.is_master_edition,
        seller_fee_basis_points: local_nft.seller_fee_basis_points,
        creators: local_nft.creators,
        share: local_nft.share.map(&:to_i),
        mint_to_public_key: ENV['COMPANY_PUBLIC_KEY'],
        network: chain_name
      }

      handle_http_request(url: url, method: 'post', payload: payload.to_json)
    end
  end
end
