# frozen_string_literal: true

module Solana
  class NftMetadataService
    def initialize(local_nft:)
      @nft = local_nft
    end

    def call
      prepare_metadata
    rescue StandardError => e
      Bugsnag.notify("Solana::NftMetadataService ERROR - #{e.message}") { |report| report.severity = 'error' }
      raise ActionController::BadRequest, 'Error when preparing metadata'
    end

    private

    attr_reader :nft

    def prepare_metadata
      aws = Aws::S3::Client.new(connection_hash)
      bucket = "nfts-#{ENV['HEROKU_ENV']}"
      key = object_key
      body = metadata_hash

      file_upload = aws.put_object(acl: 'public-read', bucket: bucket, key: key, body: body.to_json) # TODO, handle upload errors

      if file_upload.successful?
        nft.update!(metadata: body, status: :metadata_uploaded)
      else
        nft.update!(status: :failed)
        raise ActionController::BadRequest, "Metadata upload error: #{file_upload.error}"
      end

      "https://#{bucket}.s3.us-west-1.amazonaws.com/#{key}"
    end

    def connection_hash
      {
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        region: 'us-west-1'
      }
    end

    def object_key
      "#{nft.file.key.split('/')[0]}/nft_metadata_#{nft.id}.txt"
    end

    def metadata_hash
      {
        name: nft.name,
        symbol: nft.symbol,
        description: nft.description,
        seller_fee_basis_points: nft.seller_fee_basis_points,
        image: nft.file.url,
        animation_url: '',
        external_url: "www.mynftstats.io/nfts/#{nft.id}",
        attributes: [
          {
            trait_type: 'web',
            value: 'yes'
          },
          {
            trait_type: 'mobile',
            value: 'yes'
          }
        ],
        collection: {
          name: 'testing',
          family: 'tests'
        },
        properties: {
          files: [
            {
              uri: nft.file.url,
              type: nft.file.blob.content_type
            }
          ],
          category: 'image',
          creators: [
            {
              address: nft.creators[0],
              share: nft.share[0]
            }
          ]
        }
      }
    end
  end
end