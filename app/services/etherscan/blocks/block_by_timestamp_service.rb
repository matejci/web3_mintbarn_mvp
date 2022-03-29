# frozen_string_literal: true

# NOT IN USE YET
module Etherscan
  module Blocks
    class BlockByTimestampService
      def initialize(date_time:)
        @date_time = date_time # date_time format: 7.days.ago.strftime('%Y-%m-%d %H:%M:%S'), Time.now.utc.strftime('%Y-%m-%d %H:%M:%S')
      end

      def call
        find_block_data
      end

      private

      attr_reader :date_time

      def find_block_data
        url = 'https://api-rinkeby.etherscan.io/api'

        query_string = {
          'module' => 'block',
          action: 'getblocknobytime',
          timestamp: prepare_timestamp,
          closest: 'before',
          apikey: ENV['ETHERSCAN_API_KEY']
        }

        req = Faraday.new.get(url, query_string, {})

        return if req.status != 200

        JSON.parse(req.body)
      end

      def prepare_timestamp
        date_time.to_datetime.utc.to_i
      end
    end
  end
end
