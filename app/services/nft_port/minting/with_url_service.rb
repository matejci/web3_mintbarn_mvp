# frozen_string_literal: true

module NftPort
  module Minting
    class WithUrlService < BaseService
      def initialize(local_nft:, wallet_address:, chain_name:)
        @local_nft = local_nft
        @wallet_address = wallet_address
        @chain_name = chain_name
      end

      def call
        easy_mint
      rescue StandardError => e
        Bugsnag.notify("NftPort::Minting::WithUrlService ERROR - #{e.message}") { |report| report.severity = 'error' }
        raise e
      end

      private

      attr_reader :local_nft, :wallet_address, :chain_name

      def easy_mint
        url = 'https://api.nftport.xyz/v0/mints/easy/urls'

        req_body = {
          chain: Chains::MapperService.new(chain_name: chain_name).call,
          name: local_nft.name,
          description: local_nft.description,
          file_url: local_nft.file.url,
          mint_to_address: wallet_address
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