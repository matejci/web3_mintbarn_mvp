# frozen_string_literal: true

module Rarible
  module Nfts
    class BaseService
      RARIBLE_CHAINS = {
        mainnet: {
          contract_address: '0xF6793dA657495ffeFF9Ee6350824910Abc21356C',
          url: 'https://ethereum-api.rarible.org/v0.1',
          env: 'production'
        },
        rinkeby: {
          contract_address: '0x6ede7f3c26975aad32a475e1021d8f6f39c89d82',
          url: 'https://ethereum-api-staging.rarible.org/v0.1',
          env: 'staging'
        },
        ropsten: {
          contract_address: '0xB0EA149212Eb707a1E5FC1D2d3fD318a8d94cf05',
          url: 'https://ethereum-api-dev.rarible.org/v0.1',
          env: 'development'
        }
      }.freeze

      def initialize
        raise 'Implement child class!'
      end
    end
  end
end
