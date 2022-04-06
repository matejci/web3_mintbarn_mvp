# frozen_string_literal: true

module Rarible
  module Nfts
    class PrepareLazyMintDataService < BaseService
      def initialize(owner_address:, chain_name:)
        @owner_address = owner_address
        @chain_name = chain_name
      end

      def call
        prepare_data
      end

      private

      attr_reader :owner_address, :chain_name

      def prepare_data
        data = generate_token

        return data if data[:error]

        data[:contract_address] = RARIBLE_CHAINS.dig(chain_name, :contract_address)
        data
      end

      def generate_token
        req_body = { minter: owner_address }

        url = "#{RARIBLE_CHAINS.dig(chain_name, :url)}/nft/collections/#{RARIBLE_CHAINS.dig(chain_name, :contract_address)}/generate_token_id"

        req = Faraday.new.get(url, req_body, {})

        parsed_response = JSON.parse(req.body)

        return { error: parsed_response['error'] || req.body } unless req.success?

        { data: parsed_response }
      end
    end
  end
end
