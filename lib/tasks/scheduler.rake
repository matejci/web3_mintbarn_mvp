# frozen_string_literal: true

desc 'Import Solana tokens data'
task import_solana_tokens: :environment do
  CronJobs.import_solana_tokens!
end

desc 'Import NFT tokens for wallet address'
task import_nfts: :environment do
  CronJobs.import_nfts!
end
