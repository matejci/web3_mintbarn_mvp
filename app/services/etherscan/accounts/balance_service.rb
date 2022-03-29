# frozen_string_literal: true

# NOT IN USE YET
module Etherscan
  module Accounts
    class BalanceService
      def initialize(address:)
        @address = address
      end

      def call
        balance
      end

      private

      attr_reader :address

      def balance
        url = 'https://api.etherscan.io/api'

        query_string = {
          'module' => 'account',
          action: 'balance',
          address: address,
          tag: 'latest',
          apikey: ENV['ETHERSCAN_API_KEY']
        }

        req = Faraday.new.get(url, query_string, {})

        JSON.parse(req.body)
      end
    end
  end
end
