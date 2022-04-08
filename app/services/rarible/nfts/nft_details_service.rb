# frozen_string_literal: true

# WIP
module Rarible
  module Nfts
    class NftDetailsService < BaseService
      def initialize(nft_id:, chain:, wallet:)
        @nft_id = nft_id
        @chain = chain
        @wallet = wallet
      end

      def call
        nft_details
      end

      private

      attr_reader :nft_id, :chain, :wallet

      def nft_details
        s
      end
    end
  end
end

# ID of the ownership in format: '$contractAddress:$tokenId:$ownerAddress'
# https://ethereum-api.rarible.org/v0.1/nft/ownerships/{ownershipId}
