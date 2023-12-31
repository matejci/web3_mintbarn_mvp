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
                :created_at,
                :file_thumb_url,
                :magic_eden_url)
  json.file_url @nft.file.url
end
