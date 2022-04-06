# frozen_string_literal: true

module Rarible
  module Ethereum
    module Nfts
      class BaseService
        class MintError < StandardError; end

        RARIBLE_CHAINS = {
          mainnet: {
            contract_address: '0xF6793dA657495ffeFF9Ee6350824910Abc21356C',
            url: 'https://api.rarible.org/v0.1',
            url2: 'https://ethereum-api.rarible.org/v0.1',
            env: 'production'
          },
          rinkeby: {
            contract_address: '0x6ede7f3c26975aad32a475e1021d8f6f39c89d82',
            url: 'https://api-staging.rarible.org/v0.1',
            url2: 'https://ethereum-api-staging.rarible.org/v0.1',
            env: 'staging'
          },
          ropsten: {
            contract_address: '0xB0EA149212Eb707a1E5FC1D2d3fD318a8d94cf05',
            url: 'https://api-dev.rarible.org/v0.1',
            url2: 'https://ethereum-api-dev.rarible.org/v0.1',
            env: 'development'
          }
        }.freeze

        def initialize
          raise 'Implement child class!'
        end

        private

        def generate_token
          req_body = { minter: owner_address }

          url = "#{RARIBLE_CHAINS.dig(chain_name, :url2)}/nft/collections/#{RARIBLE_CHAINS.dig(chain_name, :contract_address)}/generate_token_id"

          req = Faraday.new.get(url, req_body, {})

          parsed_response = JSON.parse(req.body)

          if req.status != 200
            local_nft.status = :failed
            local_nft.mint_error = "Cannot obtain token for lazy mint: #{parsed_response['error']}"
            local_nft.save!
            raise MintError, 'Cannot obtain token for lazy mint'
          end

          local_nft.token_id = parsed_response['tokenId']
          local_nft.status = :waiting_on_signing
          local_nft.save!
        end
      end
    end
  end
end
