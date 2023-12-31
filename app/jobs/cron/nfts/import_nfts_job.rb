# frozen_string_literal: true

module Cron
  module Nfts
    class ImportNftsJob < ApplicationJob
      queue_as :cron_jobs
      sidekiq_options retry: 1

      def perform
        return unless (Time.current.hour % 12).zero?

        process_import_nfts_jobs
      rescue StandardError => e
        Bugsnag.notify(e) { |report| report.severity = 'error' }
        raise e
      end

      private

      def process_import_nfts_jobs
        WalletAccount.where.not(address: ENV['COMPANY_PUBLIC_KEY']).find_each do |wallet|
          Cron::Nfts::ImportWalletNftsJob.perform_later(wallet.address)
        end
      end
    end
  end
end
