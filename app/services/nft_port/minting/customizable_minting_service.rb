# frozen_string_literal: true

module NftPort
  module Minting
    class CustomizableMintingService < BaseService
      def initialize(local_nft:, chain:, owner_address:, contract:)
        @local_nft = local_nft
        @chain = chain
        @owner_address = owner_address
        @contract = contract
      end

      def call
        customizable_mint
      end

      private

      attr_reader :local_nft, :chain, :owner_address, :contract

      def customizable_mint
        url = 'https://api.nftport.xyz/v0/mints/customizable'

        req_body = {
          chain: Chains::MapperService.new(chain_name: chain.name).call,
          contract_address: contract.contract_address,
          metadata_uri: local_nft.metadata_uri,
          mint_to_address: owner_address
        }

        req = Faraday.new.post(url, req_body.to_json, nft_port_headers)

        parsed_response = JSON.parse(req.body)

        if req.status != 200 || parsed_response['response'] == 'NOK'
          local_nft.status = :failed
          local_nft.mint_error = parsed_response['error'] || parsed_response.dig('detail', 0, 'msg')
          local_nft.save!
          return { error: parsed_response['error'] }
        end

        local_nft.contract_address = parsed_response['contract_address']
        local_nft.transaction_hash = parsed_response['transaction_hash']
        local_nft.transaction_external_url = parsed_response['transaction_external_url']
        local_nft.status = :minted
        local_nft.save!

        { nft: local_nft }
      end
    end
  end
end
