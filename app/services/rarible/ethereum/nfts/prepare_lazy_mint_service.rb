# frozen_string_literal: true

module Rarible
  module Ethereum
    module Nfts
      class PrepareLazyMintService < BaseService
        def initialize(owner_address:, local_nft:, chain_name:)
          @owner_address = owner_address
          @local_nft = local_nft
          @chain_name = chain_name
        end

        def call
          prepare_data
        end

        private

        attr_reader :owner_address, :local_nft, :chain_name

        def prepare_data
          generate_token

          { nft: local_nft, contract_address: RARIBLE_CHAINS.dig(chain_name, :contract_address) }
        end
      end
    end
  end
end
