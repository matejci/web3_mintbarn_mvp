# frozen_string_literal: true

module Nfts
  class CreateService
    def initialize(name:, description:, file:, chain:, wallet:)
      @name = name
      @description = description
      @file = file
      @chain = chain
      @wallet = wallet
    end

    def call
      # TODO, check for token balance on specified chain before creation
      mint_nft(create_local_nft)
    end

    private

    attr_reader :name, :description, :file, :chain, :wallet

    def create_local_nft
      nft = wallet.nfts.create!(name: name, description: description, chain: chain)
      nft.file.attach(file)
      nft
    end

    def mint_nft(nft)
      NftPort::Minting::WithUrlService.new(local_nft: nft, wallet_address: wallet.address, chain_name: chain.name).call
    end
  end
end
