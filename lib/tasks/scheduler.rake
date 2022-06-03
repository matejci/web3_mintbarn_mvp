# frozen_string_literal: true

desc 'Import Solana tokens data'
task import_solana_tokens: :environment do
  CronJobs.import_solana_tokens!
end

desc 'Import NFT tokens for wallet address'
task import_nfts: :environment do
  CronJobs.import_nfts!
end

desc 'NFT activity checks'
task nft_activity_checks: :environment do
  CronJobs.check_nft_activities!
end

desc 'Estimate Mint fees'
task estimate_mint_fees: :environment do
  CronJobs.estimate_mint_fees!
end
