# frozen_string_literal: true

module CronJobs
  class << self
    def import_eth_values!
      Cron::ImportEthValueJob.perform_later
    end
  end
end
