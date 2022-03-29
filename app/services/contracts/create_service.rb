# frozen_string_literal: true

module Contracts
  class CreateService
    def initialize(name:, contract_symbol:, contract_type:, chain:, wallet:)
      @name = name
      @contract_symbol = contract_symbol
      @contract_type = contract_type
      @chain = chain
      @wallet = wallet
    end

    def call
      create_ethereum_contract(create_local_contract)
    end

    private

    attr_reader :name, :contract_symbol, :contract_type, :chain, :wallet

    def create_local_contract
      Contract.create!(name: name, contract_symbol: contract_symbol, contract_type: contract_type,
                       chain: chain, owner_address: wallet.address)
    end

    def create_ethereum_contract(contract)
      NftPort::Contracts::DeployService.new(contract: contract, chain_name: chain.name).call
    end
  end
end
