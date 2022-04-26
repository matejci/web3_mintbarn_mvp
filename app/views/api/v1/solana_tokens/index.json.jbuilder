# frozen_string_literal: true

json.data do
  json.extract!(@token, :id, :name, :symbol, :mint_address, :icon_url, :website, :market_cap_rank, :price_ust)
end
