# frozen_string_literal: true

class NftMintAndListJob < ApplicationJob
  queue_as :mint_and_list
  sidekiq_options retry: 3

  def perform(nft_id:, chain_name:)
    mint_and_list(nft_id, chain_name)
  rescue StandardError => e
    Bugsnag.notify(e) { |report| report.severity = 'error' }
    raise e
  end

  private

  def mint_and_list(nft_id, chain_name)
    nft = Nft.find(nft_id)

    nft.update!(file_thumb_url: nft.file.variant(resize_to_limit: [250, 250]).processed.url)

    mint(nft, chain_name) unless nft.status == 'minted'
    list(nft, chain_name)
  end

  def mint(nft, chain_name)
    Solana::NftMetadataService.new(local_nft: nft).call if nft.status != 'metadata_uploaded'

    mint_response = Solana::MintNftService.new(local_nft: nft, chain_name: chain_name).call

    nft_attrs = {
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

  def list(nft, chain_name)
    list_response = Solana::ListNftService.new(chain_name: chain_name, mint_address: nft.mint_address, price: nft.price_in_lamports).call
    nft.update!(list_tx_signature: list_response['transaction_signature'],
                status: :listed,
                listed_at: Time.current,
                magic_eden_url: list_response.dig('nft_listing'))
  end
end
