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
  end
end
