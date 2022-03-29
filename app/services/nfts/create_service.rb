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
      contract = validate_contract
      local_nft = create_local_nft
      nft_data = upload_metadata(local_nft)
      mint_nft(nft_data, contract)
    end

    private

    attr_reader :name, :description, :file, :chain, :wallet

    def validate_contract
      contract = Contract.completed.where(chain_id: chain.id).first

      raise ActionController::BadRequest, 'Contract for given chain does not exist' unless contract

      contract
    end

    def create_local_nft
      nft = wallet.nfts.create!(name: name, description: description, chain: chain, external_url: 'mynftstats.io')
      nft.file.attach(file)
      nft
    end

    def upload_metadata(nft)
      NftPort::Storage::UploadMetadataService.new(local_nft: nft).call
    end

    def mint_nft(nft, contract)
      NftPort::Minting::CustomizableMintingService.new(local_nft: nft, chain: chain, owner_address: wallet.address, contract: contract).call
    end
  end
end
