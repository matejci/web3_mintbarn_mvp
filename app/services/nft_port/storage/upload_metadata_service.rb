# frozen_string_literal: true

# TODO, adjust and refactor this once ready for prod
module NftPort
  module Storage
    class UploadMetadataService < BaseService
      def initialize(local_nft:)
        @local_nft = local_nft
      end

      def call
        upload_metadata
      end

      private

      attr_reader :local_nft

      def upload_metadata
        url = 'https://api.nftport.xyz/v0/metadata'

        req_body = {
          name: local_nft.name,
          description: local_nft.description,
          file_url: local_nft.file.url,
          external_url: local_nft.external_url
        }

        req = Faraday.new.post(url, req_body.to_json, nft_port_headers)

        parsed_response = JSON.parse(req.body)

        if req.status != 200 || parsed_response['response'] == 'NOK'
          local_nft.status = :failed
          local_nft.mint_error = parsed_response['error'] || parsed_response.dig('detail', 0, 'msg')
          local_nft.save!
          raise parsed_response['error']
        end

        local_nft.metadata_uri = parsed_response['metadata_uri']
        local_nft.status = :metadata_uploaded
        local_nft.save!
        local_nft
      end
    end
  end
end
