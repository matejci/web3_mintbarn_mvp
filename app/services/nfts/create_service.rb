# frozen_string_literal: true

module Nfts
  class CreateService
    def initialize(params:, chain:, wallet:)
      @b58_private_key = params[:b58_private_key]
      @name = params[:name]
      @file = params[:file]
      @symbol = params[:symbol].presence || ''
      @description = params[:description]
      @is_mutable = params[:is_mutable]
      @seller_fee_basis_points = params[:seller_fee_basis_points]
      @creators = params[:creators]
      @share = params[:share]
      @mint_to_public_key = params[:mint_to_public_key]
      @chain = chain
      @wallet = wallet
    end

    def call
      # TODO, check for available credits for wallet address before proceeding
      validate_params
      local_nft = create_local_nft
      mint_nft(local_nft)
    rescue StandardError => e
      error_msg = e.message
      Bugsnag.notify("NFTS::CreateService ERROR - #{error_msg}") { |report| report.severity = 'error' }
      raise ActionController::BadRequest, error_msg
    end

    private

    attr_reader :b58_private_key, :name, :file, :symbol, :description, :is_mutable, :seller_fee_basis_points, :creators, :share, :mint_to_public_key, :chain, :wallet

    def validate_params
      raise ActionController::BadRequest, 'Creators param must be array' unless creators.is_a?(Array) && creators.present?
      raise ActionController::BadRequest, 'Share param must be array' unless share.is_a?(Array) && share.present?
      raise ActionController::BadRequest, 'File param missing' if file.blank?
    end

    def create_local_nft
      nft = wallet.nfts.create!(name: name,
                                symbol: symbol,
                                description: description,
                                is_mutable: is_mutable,
                                seller_fee_basis_points: seller_fee_basis_points.to_i,
                                creators: creators,
                                share: share,
                                mint_to_public_key: mint_to_public_key.presence || wallet.address,
                                chain: chain)
      nft.file.attach(file)
      nft
    end

    def mint_nft(nft)
      metadata_url = Solana::NftMetadataService.new(local_nft: nft).call
      mint_response = Solana::MintNftService.new(private_key: b58_private_key, local_nft: nft, metadata_url: metadata_url, chain: chain).call

      nft_attrs = {
        metadata_url: metadata_url,
        explorer_url: mint_response['explorer_url'],
        mint: mint_response['mint'],
        mint_secret_recovery_phrase: mint_response['mint_secret_recovery_phrase'],
        primary_sale_happened: mint_response['primary_sale_happened'],
        transaction_signature: mint_response['transaction_signature'],
        update_authority: mint_response['update_authority'],
        status: :minted
      }

      nft.update!(nft_attrs)
      nft
    end
  end
end
