# frozen_string_literal: true

module Cron
  module Nfts
    class ActivityChecksJob < ApplicationJob
      queue_as :cron_jobs
      sidekiq_options retry: 1

      def perform
        check_nfts_activities
      rescue StandardError => e
        Bugsnag.notify(e) { |report| report.severity = 'error' }
        raise e
      end

      private

      def check_nfts_activities
        Nft.listed.find_each do |nft|
          Cron::Nfts::NftActivityJob.perform_later(nft.id)
        end
      end
    end
  end
end
