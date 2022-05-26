# frozen_string_literal: true

json.total_pages @collection[:total_pages]

json.data do
  json.array!(@collection[:data]) do |nft|
    json.extract!(nft,
                  :id,
                  :name,
                  :description,
                  :symbol,
                  :explorer_url,
                  :mint_address,
                  :seller_fee_basis_points,
                  :price_in_lamports,
                  :creators,
                  :share,
                  :status,
                  :created_at,
                  :file_thumb_url,
                  :magic_eden_url)
    json.file_url nft.file.url.presence || nft.file_thumb_url
  end
end
