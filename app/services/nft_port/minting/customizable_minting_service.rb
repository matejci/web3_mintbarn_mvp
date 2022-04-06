# frozen_string_literal: true

module NftPort
  module Minting
    class CustomizableMintingService < BaseService
      def initialize(metadata_uri:, chain_name:, owner_address:, contract_address:)
        @metadata_uri = metadata_uri
        @chain_name = chain_name
        @owner_address = owner_address
        @contract_address = contract_address
      end

      def call
        customizable_mint
      end

      private

      attr_reader :metadata_uri, :chain_name, :owner_address, :contract_address

      def customizable_mint
        url = 'https://api.nftport.xyz/v0/mints/customizable'

        req_body = {
          chain: Chains::MapperService.new(chain_name: chain_name).call,
          contract_address: contract_address,
          metadata_uri: metadata_uri,
          mint_to_address: owner_address
        }

        req = Faraday.new.post(url, req_body.to_json, nft_port_headers)

        parsed_response = JSON.parse(req.body)

        return { error: parsed_response['error'] || req.body } unless req.success?

        { data: parsed_response }
      end
    end
  end
end
