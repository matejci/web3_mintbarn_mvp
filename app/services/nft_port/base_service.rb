# frozen_string_literal: true

module NftPort
  class BaseService
    def initialize
      raise 'Implement child class!'
    end

    private

    def nft_port_headers
      { authorization: ENV['NFTPORT_API_KEY'], 'content-type' => 'application/json' }
    end

    def current_contract
      contract_symbol = { 'local' => 'test',
                          'development' => 'mynftstats-dev',
                          'production' => 'mynftstats' }

      heroku_env = ENV['HEROKU_ENV']

      Rails.cache.fetch("#{heroku_env}_contract") do
        Contract.completed.where(contract_symbol: contract_symbol[heroku_env]).first
      end
    end
  end
end
