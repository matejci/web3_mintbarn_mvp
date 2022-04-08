# frozen_string_literal: true

json.nft do
  json.extract! @collection[:nft], :id, :name, :description, :wallet_account_id, :chain_id, :status, :contract_address, :transaction_hash, :transaction_external_url,
  :mint_error, :created_at, :updated_at, :external_url, :signature, :token_id, :mint_type

  json.metadata_uri @collection[:nft].metadata_uri.gsub('ipfs://', '/ipfs/')
end

json.contract_address @collection[:contract_address]
