# frozen_string_literal: true

# TODO, adjust and refactor this once ready for prod
module NftPort
  module Storage
    class UploadMetadataService < BaseService
      def initialize(name:, description:, file_url:, external_url:)
        @name = name
        @description = description
        @file_url = file_url
        @external_url = external_url
      end

      def call
        upload_metadata
      end

      private

      attr_reader :name, :description, :file_url, :external_url

      def upload_metadata
        url = 'https://api.nftport.xyz/v0/metadata'

        req_body = {
          name: name,
          description: description,
          file_url: file_url,
          external_url: external_url
        }

        req = Faraday.new.post(url, req_body.to_json, nft_port_headers)

        parsed_response = JSON.parse(req.body)

        return { error: parsed_response['error'] || req.body } unless req.success?

        { data: parsed_response }
      end
    end
  end
end
