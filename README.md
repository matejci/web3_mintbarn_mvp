# Mintbarn API/WEB

## Requirements - Tech stack:
- Ruby 3.1.1
- Rails 7.0.2
- Postgresql 10
- Redis 4

## Starting up the API/WEB server:
- bundle exec rails db:create
- bundle exec rails db:migrate
- bundle exec rails db:seed
- rails s (or bundle exec puma -C config/puma.rb)

## 3rd party services:
- The Blockchain API (https://docs.blockchainapi.com)
- Magic Eden API (https://api-mainnet.magiceden.dev)
- Solscan
- AWS S3
- IPFS via Pinata API (https://docs.pinata.cloud/pinata-api)

## Cron jobs:
- import_solana_tokens
	- used to import/update all Solana tokens, daily
	- should be scheduled to run once a day
- import_nfts
	- used to import NFTs from wallets so our DB is in sync with user's wallet(s), because user might have NFTs in his wallet from another sources, not just Mintbarn
	- should be scheduled to run twice a day, every 12h
- nft_activities_check
  - used to check if NFT is bought (first sale)
  - if NFT is bought, it will transfer funds to appropriate wallet(s) and update NFT in our DB
  - should be scheduled to run every hour or so
- estimate_mint_fees
	- used to estimate fees for minting and listing of NFT, should be scheduled to run once a day

## Heroku ENVS
- since we never released the app officialy, we only have 2 Heroku ENVs:
  - DEV - https://mynftstats-dev.herokuapp.com - used for testing and development
  - PROD - https://mintbarn.herokuapp.com - (which is never fully released)

## About
- API acts as a proxy between FE app and Solana blockchain
- it is used to store and track user's NFTs in local DB and also on IPFS/AWS services
- it caches some data like SOL price in USD, etc..

### Wallet registration
- in order for user (wallet) to be able to mint NFT on Solana blockchain using Mintbarn API, users first needs to register their wallet account
- user can register multiple wallet accounts (currently wallet account is not associated with the user)
- endpoint: POST http://mintbarn.io/wallets.json

### Minting & Listing NFTs
- when minting the NFT user doesn't need to have any SOLs on their wallet balance
- minting and listing fees on Solana are payed with company's funds, which means that in order for everything to function properly, company's wallet need to be topped with some SOLs
- since we don't require our users to have SOLs in order to mint and list an NFT, we use our own wallet to pay for the fees, but that means that all created NFTs will be owned by company's wallet. This is just temporarily until NFT is delisted or sold
- if user decide to delist the NFT, it will be back to his wallet (we currently don't have delist option)
- if someone buys the NFT, Solana will transfer funds to our company's wallet and then system will calculate and distribute proper funds to proper user's wallet (this is still in development and it wasn't tested because we were blocked by Magic Eden)
- endpoint: POST http://mintbarn.io/nfts.json

#### Future development:
- merge `ipfs` branch to `master` - this introduced moving of uploads of NFT images from AWS service to IPFS decentralized storage
- test funds transfer after NFT is bought on market place
- write tests
- generate API endpoint docs
- ...
