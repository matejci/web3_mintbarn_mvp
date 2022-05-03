# frozen_string_literal: true

json.data do
  json.array!(@collection) do |nft|
    json.extract!(nft, :id, :name, :description, :symbol, :explorer_url, :mint_address, :seller_fee_basis_points, :price_in_lamports, :creators, :share, :status, :created_at)
    json.file_url nft.file.url
  end
end
