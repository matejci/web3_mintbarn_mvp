# frozen_string_literal: true

module Chains
  class MapperService
    def initialize(chain_name:)
      @chain_name = chain_name
    end

    def call
      map_chains
    end

    private

    attr_reader :chain_name

    def map_chains
      case chain_name.downcase
      when 'mainnet', 'polygon'
        'polygon'
      else
        'rinkeby'
      end
    end
  end
end
