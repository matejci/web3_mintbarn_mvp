# frozen_string_literal: true

json.data do
  json.extract!(@nft,
                :id,
                :name,
                :description,
                :symbol,
                :explorer_url,
                :status)
end
