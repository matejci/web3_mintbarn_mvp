# frozen_string_literal: true

json.data do
  json.extract!(@nft,
                :id,
                :name,
                :description,
                :symbol,
                :explorer_url,
                :mint_address,
                :seller_fee_basis_points,
                :price_in_lamports,
                :status,
                :creators,
                :share,
                :created_at)
  json.file_url @nft.file.url
end
