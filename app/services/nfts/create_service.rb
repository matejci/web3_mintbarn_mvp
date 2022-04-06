# frozen_string_literal: true

module Nfts
  class CreateService
    def initialize(name:, description:, signature:, file:, mint_type:, chain:, wallet:)
      @name = name
      @description = description
      @signature = signature
      @file = file
      @mint_type = mint_type
      @chain = chain
      @wallet = wallet
    end

    def call
      # TODO, check for token balance on specified chain before creation

      contract = validate_contract if mint_type == 'normal'
      local_nft = create_local_nft
      nft_data = upload_metadata(local_nft)
      mint_nft(nft_data, contract)
    end

    private

    attr_reader :name, :description, :signature, :file, :mint_type, :chain, :wallet

    def validate_contract
      contract = Contract.completed.where(chain_id: chain.id).first

      raise ActionController::BadRequest, 'Contract for given chain does not exist' unless contract

      contract
    end

    def create_local_nft
      nft = wallet.nfts.create!(name: name,
                                description: description,
                                chain: chain,
                                signature: signature,
                                mint_type: mint_type,
                                external_url: 'mynftstats.io')
      nft.file.attach(file)
      nft
    end

    def upload_metadata(nft)
      NftPort::Storage::UploadMetadataService.new(local_nft: nft).call
    end

    def mint_nft(nft, contract)
      if mint_type == 'lazy'
        Rarible::Ethereum::Nfts::PrepareLazyMintService.new(owner_address: wallet.address, local_nft: nft, chain_name: chain.name.downcase.to_sym).call
      else
        NftPort::Minting::CustomizableMintingService.new(local_nft: nft, chain: chain, owner_address: wallet.address, contract: contract).call
      end
    end
  end
end
