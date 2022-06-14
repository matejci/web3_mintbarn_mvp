# frozen_string_literal: true

module Cron
  module Nfts
    class ImportWalletNftsJob < ApplicationJob
      queue_as :cron_jobs
      sidekiq_options retry: 3

      def perform(wallet_address)
        import_nfts(wallet_address)
      rescue StandardError => e
        Bugsnag.notify(e) { |report| report.severity = 'error' }
        raise e
      end

      private

      def import_nfts(wallet_address)
        wallet = WalletAccount.find_by!(address: wallet_address)
        keep_mint_addresses = []

        response = Solana::NftsImportService.new(wallet_address: wallet_address, chain_name: chain.last.downcase).call

        response['nfts_metadata'].each do |nft|
          mint_address = nft['mint']
          keep_mint_addresses << mint_address

          local_nft = Nft.find_by(mint_address: mint_address)

          if local_nft
            local_nft.update_columns(status: :minted, wallet_account_id: wallet.id)
          else
            create_new_nft(nft, wallet, mint_address)
          end
        end

        update_nfts = wallet.nfts.where.not(mint_address: keep_mint_addresses)
        update_nfts.each { |nft| nft.update_columns(status: :archived, wallet_account_id: nil) }
      end

      def create_new_nft(nft, wallet, mint_address)
        nft_attrs = { name: nft.dig('data', 'name'),
                      symbol: nft.dig('data', 'symbol'),
                      description: nft.dig('off_chain_data', 'description'),
                      is_mutable: nft['is_mutable'],
                      seller_fee_basis_points: nft.dig('data', 'seller_fee_basis_points'),
                      creators: nft.dig('data', 'creators'),
                      share: nft.dig('data', 'share'),
                      chain_id: chain.first,
                      metadata_url: nft.dig('data', 'uri'),
                      metadata: nft['off_chain_data'],
                      primary_sale_happened: nft['primary_sale_happened'],
                      explorer_url: nft['explorer_url'],
                      mint_address: mint_address,
                      update_authority: nft['update_authority'],
                      status: :minted,
                      file_thumb_url: nft.dig('off_chain_data', 'image'),
                      mint_to_public_key: nft.dig('data', 'creators').first,
                      magic_eden_url: chain.last == 'Mainnet-beta' ? "https://magiceden.io/item-details/#{mint_address}" : nil }

        wallet.nfts.insert(nft_attrs)
      end

      def chain
        @chain ||= begin
          chain_name = case ENV.fetch('HEROKU_ENV', '')
                       when 'local', 'development'
                         'Devnet'
                       else
                         'Mainnet-beta'
          end

          [Chain.find_by(name: chain_name).id, chain_name]
        end
      end
    end
  end
end
