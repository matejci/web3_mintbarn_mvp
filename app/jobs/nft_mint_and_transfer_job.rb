# frozen_string_literal: true

class NftMintAndTransferJob < ApplicationJob
  queue_as :mint_and_transfer
  sidekiq_options retry: 5

  def perform(nft_id:, chain_name:)
    mint_and_transfer(nft_id, chain_name)
  rescue StandardError => e
    Bugsnag.notify(e) { |report| report.severity = 'error' }
    raise e
  end

  private

  def mint_and_transfer(nft_id, chain_name)
    nft = Nft.find(nft_id)

    nft.update!(file_thumb_url: nft.file.variant(resize_to_limit: [250, 250]).processed.url)

    mint(nft, chain_name) unless nft.status == 'minted'
    transfer(nft, chain_name)
  end

  def mint(nft, chain_name)
    metadata_url = Solana::NftMetadataService.new(local_nft: nft).call
    mint_response = Solana::MintNftService.new(local_nft: nft, metadata_url: metadata_url, chain_name: chain_name).call

    nft_attrs = {
      metadata_url: metadata_url,
      explorer_url: mint_response['explorer_url'],
      mint_address: mint_response['mint'],
      mint_secret_recovery_phrase: mint_response['mint_secret_recovery_phrase'],
      primary_sale_happened: mint_response['primary_sale_happened'],
      transaction_signature: mint_response['transaction_signature'],
      update_authority: mint_response['update_authority'],
      status: :minted
    }

    nft.update!(nft_attrs)
  end

  def transfer(nft, chain_name)
    transfer_response = Solana::TransferNftService.new(recipient: nft.mint_to_public_key, token_address: nft.mint_address, chain_name: chain_name).call

    nft.update!(status: :transfered, transfer_tx_signature: transfer_response['transaction_signature'])
  end
end
