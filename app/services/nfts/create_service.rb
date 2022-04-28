# frozen_string_literal: true

# rubocop: disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
module Nfts
  class CreateService
    ALLOWED_FILE_TYPES = %w[image/png image/jpeg].freeze

    def initialize(params:, chain:, wallet:)
      @signature = params[:signature]
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

    attr_reader :signature, :name, :file, :symbol, :description, :is_mutable, :seller_fee_basis_points, :creators, :share, :mint_to_public_key, :chain, :wallet

    def validate_params
      raise ActionController::BadRequest, 'Creators param must be array' unless creators.is_a?(Array) && creators.present?
      raise ActionController::BadRequest, 'Share param must be array' unless share.is_a?(Array) && share.present?
      raise ActionController::BadRequest, 'File param missing' if file.blank?
      raise ActionController::BadRequest, 'File extension not allowed' unless file.content_type.in?(ALLOWED_FILE_TYPES)
      raise ActionController::BadRequest, 'Length of the creator list must match length of the list of share' unless creators.size == share.size
      raise ActionController::BadRequest, 'Length of the lists must be between 1 and 5' unless share.empty? || share.size > 5

      validate_share
    end

    def validate_share
      error = share.find { |item| item.to_i.negative? || item.to_i > 100 }

      raise ActionController::BadRequest, 'Share values must be between 0 and 100' if error
      raise ActionController::BadRequest, 'Sum of share values must equal 100' if share.map!(&:to_i).sum != 100
    end

    def create_local_nft
      nft = wallet.nfts.create!(signature: signature,
                                name: name,
                                symbol: symbol,
                                description: description,
                                is_mutable: is_mutable,
                                seller_fee_basis_points: seller_fee_basis_points.to_i,
                                creators: creators << ENV['COMPANY_PUBLIC_KEY'],
                                share: share << 0,
                                mint_to_public_key: mint_to_public_key.presence || wallet.address,
                                chain: chain)
      nft.file.attach(file)
      nft
    end

    def mint_nft(nft)
      metadata_url = Solana::NftMetadataService.new(local_nft: nft).call
      mint_response = Solana::MintNftService.new(local_nft: nft, metadata_url: metadata_url, chain: chain).call

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
# rubocop: enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
