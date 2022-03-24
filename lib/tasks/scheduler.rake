# frozen_string_literal: true

desc 'Import ETH historical values'
task import_eth_values: :environment do
  CronJobs.import_eth_values!
end
