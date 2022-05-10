# frozen_string_literal: true

module CronJobs
  class << self
    def import_solana_tokens!
      Cron::ImportSolanaTokensJob.perform_later
    end

    def import_nfts!
      Cron::Nfts::ImportNftsJob.perform_later
    end
  end
end
