# frozen_string_literal: true

# NOT IN USE YET
module Etherscan
  module Accounts
    class BalanceService
      ALLOWED_CHAINS = %w[Rinkeby Mainnet].freeze

      def initialize(address:, chain:)
        @address = address
        @chain = chain
      end

      def call
        validation
        balance
      end

      private

      attr_reader :address, :chain

      def validation
        raise ActionController::BadRequest, "#{chain.name} not allowed" unless chain.name.in?(ALLOWED_CHAINS)
      end

      def balance
        query_string = {
          'module' => 'account',
          action: 'balance',
          address: address,
          tag: 'latest',
          apikey: ENV['ETHERSCAN_API_KEY']
        }

        req = Faraday.new.get(chain.etherscan_api_url, query_string, {})

        JSON.parse(req.body)
      end
    end
  end
end
