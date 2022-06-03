# frozen_string_literal: true

module Cron
  module Nfts
    class EstimateMintFeesJob < ApplicationJob
      queue_as :cron_jobs
      sidekiq_options retry: 3

      def perform
        return unless (Time.current.hour % 4).zero?

        estimate_mint_fees
      rescue StandardError => e
        Bugsnag.notify(e) { |report| report.severity = 'error' }
        raise e
      end

      private

      def estimate_mint_fees
        nft = Nft.find_by(name: 'MINTBARNESTIMATIONTOKEN')
        chain = Chain.devnet

        balance_before = Solana::BalanceService.new(chain: chain).call
        mint(nft)
        list(nft)
        balance_after = Solana::BalanceService.new(chain: chain).call
        Rails.cache.delete('min_mint_lamports_balance')
        App.ios.first.update!(min_mint_lamports_balance: balance_before - balance_after)

        balance_before = balance_after
        transfer_sol(nft)
        balance_after = Solana::BalanceService.new(chain: chain).call
        Rails.cache.delete('min_transfer_lamports_balance')
        App.ios.first.update!(min_transfer_lamports_balance: balance_before - balance_after)
      end

      def mint(nft)
        Solana::NftMetadataService.new(local_nft: nft).call if nft.metadata_url.nil?

        mint_response = Solana::MintNftService.new(local_nft: nft, chain_name: 'devnet').call

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

      def list(nft)
        list_response = Solana::ListNftService.new(chain_name: 'devnet', mint_address: nft.mint_address, price: nft.price_in_lamports).call
        nft.update!(list_tx_signature: list_response['transaction_signature'],
                    status: :listed,
                    listed_at: Time.current,
                    magic_eden_url: list_response.dig('nft_listing'))
      end

      def transfer_sol(nft)
        Solana::TransferFundsService.new(nft: nft).call
      end
    end
  end
end
