# frozen_string_literal: true

module Cron
  module Nfts
    class NftActivityJob < ApplicationJob
      queue_as :cron_jobs
      sidekiq_options retry: 2

      def perform(id)
        nft_activities(id)
      rescue StandardError => e
        Bugsnag.notify(e) { |report| report.severity = 'error' }
        raise e
      end

      private

      def nft_activities(id)
        nft = Nft.find(id)

        activities = Solana::NftActivitiesService.new(mint_address: nft.mint_address).call

        bought_data = activities.find { |a| a['type'] == 'buyNow' && a['seller'] == ENV['COMPANY_PUBLIC_KEY'] && a['buyer'].present? }

        return unless bought_data

        update_attrs = {
          first_purchase: bought_data,
          status: :bought,
          bought_at: Time.current
        }

        nft.update!(update_attrs)

        TransferFundsJob.perform_later(nft.id)
      end
    end
  end
end
