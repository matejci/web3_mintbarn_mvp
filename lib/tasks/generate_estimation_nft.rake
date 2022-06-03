# frozen_string_literal: true

desc 'Generate NFT used to estimate mint fees'
task generate_estimation_nft: :environment do
  wallet = WalletAccount.find_by(address: ENV['COMPANY_PUBLIC_KEY'])

  nft = wallet.nfts.create!(name: 'MINTBARNESTIMATIONTOKEN',
                            price_in_lamports: 2000,
                            symbol: 'MBET',
                            description: 'Token used to estimate ming + listing fees',
                            is_mutable: false,
                            seller_fee_basis_points: 100,
                            creators: [wallet.address],
                            share: [100],
                            mint_to_public_key: '6C5iJBp4QCykQraUTnMJtDtdWc6Ro1Qiav92QLQ3E1ff',
                            chain: Chain.find_by(name: 'Devnet'))

  file = URI.parse('https://world-geography-games.com/img/home-america1.png').open
  nft.file.attach(io: file, filename: 'estimation_nft.png')
end
