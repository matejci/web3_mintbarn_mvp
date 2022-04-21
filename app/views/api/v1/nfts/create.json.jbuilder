# frozen_string_literal: true

json.data do
  json.extract!(@nft, :name, :description, :symbol, :metadata_url, :transaction_signature, :explorer_url, :status)
end
