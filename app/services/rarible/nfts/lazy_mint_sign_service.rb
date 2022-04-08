# frozen_string_literal: true

module Rarible
  module Nfts
    class LazyMintSignService < BaseService
      def initialize(nft_id:, signature:, creators:, royalties:, chain_name:, owner_address:)
        @nft_id = nft_id
        @signature = signature
        @creators = creators
        @royalties = royalties
        @chain_name = chain_name
        @owner_address = owner_address
      end

      def call
        nft = fetch_local_nft
        lazy_mint_nft(nft)
      end

      private

      attr_reader :nft_id, :signature, :creators, :royalties, :chain_name, :owner_address

      def fetch_local_nft
        Nft.waiting_on_signing.find(nft_id)
      end

      def lazy_mint_nft(nft)
        url = "#{RARIBLE_CHAINS[chain_name][:url]}/nft/mints"

        req_body = {
          contract: RARIBLE_CHAINS[chain_name][:contract_address],
          uri: nft.metadata_uri.gsub('ipfs://', '/ipfs/'),
          royalties: parse_creators_royalties(royalties),
          creators: parse_creators_royalties(creators),
          tokenId: nft.token_id,
          :@type => 'ERC721',
          signatures: [signature]
        }

        req = Faraday.new.post(url, req_body.to_json, { 'content-type': 'application/json' })

        parsed_response = JSON.parse(req.body)

        if req.success?
          { data: parsed_response }
        else
          error = parsed_response['message'] || req.body

          nft.update!(status: :failed, mint_error: error)

          raise ActionController::BadRequest, "LazyMintSignService error: #{error}"
        end
      end

      def parse_creators_royalties(collection)
        return [] unless collection

        collection.each_with_object([]) do |item, results|
          results << { account: item['account'], value: item['value'] }
        end
      end

      # def data_structure_to_sign(token_id)
      #   {
      #     types: {
      #       EIP712Domain: [
      #         {
      #           type: 'string',
      #           name: 'name'
      #         },
      #         {
      #           type: 'string',
      #           name: 'version'
      #         },
      #         {
      #           type: 'uint256',
      #           name: 'chainId'
      #         },
      #         {
      #           type: 'address',
      #           name: 'verifyingContract'
      #         }
      #       ],
      #       Mint721: [
      #         { name: '@type', type: 'string' },
      #         { name: 'contract', type: 'address' },
      #         { name: 'tokenId', type: 'uint256' },
      #         { name: 'tokenURI', type: 'string' },
      #         { name: 'uri', type: 'string' },
      #         { name: 'creators', type: 'Part[]' },
      #         { name: 'royalties', type: 'Part[]' }
      #       ],
      #       Part: [{ name: 'account', type: 'address' }, { name: 'value', type: 'uint96' }]
      #     },
      #     domain: {
      #       name: 'Mint721',
      #       version: '1',
      #       chainId: 3,
      #       verifyingContract: ROPSTEN_CONTRACT_ADDRESS
      #     },
      #     primaryType: 'Mint721',
      #     message: {
      #       :@type => 'ERC721',
      #       contract: ROPSTEN_CONTRACT_ADDRESS,
      #       tokenId: token_id,
      #       tokenURI: metadata_uri,
      #       uri: metadata_uri,
      #       creators: [
      #         {
      #           account: owner_address,
      #           value: 10000
      #         }
      #       ],
      #       royalties: [
      #         {
      #           account: owner_address,
      #           value: 2000
      #         }
      #       ]
      #     }
      #   }
      # end
    end
  end
end
