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
        wallet = WalletAccount.includes(:nfts).find_by!(address: wallet_address)
        chain_name = resolve_chain
        chain = Chain.find_by(name: chain_name)

        response = Solana::NftsImportService.new(wallet_address: wallet_address, chain_name: chain_name.downcase).call

        response['nfts_metadata'].each do |nft|
          local_nft = wallet.nfts.find { |item| item.mint_address == nft['mint'] }

          next if local_nft

          nft_attrs = { name: nft.dig('data', 'name'),
                        symbol: nft.dig('data', 'symbol'),
                        is_mutable: nft['is_mutable'],
                        seller_fee_basis_points: nft.dig('data', 'seller_fee_basis_points'),
                        creators: nft.dig('data', 'creators'),
                        share: nft.dig('data', 'share'),
                        chain: chain,
                        metadata_url: nft.dig('data', 'uri'),
                        metadata: nft['off_chain_data'],
                        primary_sale_happened: nft['primary_sale_happened'],
                        explorer_url: nft['explorer_url'],
                        mint_address: nft['mint'],
                        update_authority: nft['update_authority'],
                        status: :imported,
                        file_thumb_url: nft.dig('off_chain_data', 'image') }

          wallet.nfts.create!(nft_attrs)
        end
      end

      def resolve_chain
        case ENV.fetch('HEROKU_ENV', '')
        when 'local', 'development'
          'Devnet'
        else
          'Mainnet-beta'
        end
      end
    end
  end
end
