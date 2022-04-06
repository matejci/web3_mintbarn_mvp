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
      upload_metadata(local_nft)
      mint_nft(local_nft, contract)
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
      data = NftPort::Storage::UploadMetadataService.new(name: nft.name, description: nft.description, file_url: nft.file.url, external_url: nft.external_url).call

      handle_service_errors(nft, data[:error], 'UploadMetadataService') if data[:error]
      nft.update!(status: :metadata_uploaded, metadata_uri: data[:data]['metadata_uri'])
      nft
    end

    def mint_nft(nft, contract)
      if mint_type == 'lazy'
        data = Rarible::Nfts::PrepareLazyMintDataService.new(owner_address: wallet.address, chain_name: chain.name.downcase.to_sym).call

        handle_service_errors(nft, data[:error], 'PrepareLazyMintDataService') if data[:error]

        nft.update!(status: :waiting_on_signing, token_id: data[:data]['tokenId'])

        { nft: nft, contract_address: data[:contract_address] }
      else
        data = NftPort::Minting::CustomizableMintingService.new(metadata_uri: nft.metadata_uri,
                                                                chain_name: chain.name,
                                                                owner_address: wallet.address,
                                                                contract_address: contract.contract_address).call

        handle_service_errors(nft, data[:error], 'CustomizableMintingService') if data[:error]

        service_data = data[:data]

        nft.update!(status: :minted,
                    contract_address: service_data['contract_address'],
                    transaction_hash: service_data['transaction_hash'],
                    transaction_external_url: service_data['transaction_external_url'])

        { nft: nft }
      end
    end

    def handle_service_errors(nft, error, service)
      nft.update!(status: :failed, mint_error: error)

      raise ActionController::BadRequest, "#{service} error: #{error}"
    end
  end
end
