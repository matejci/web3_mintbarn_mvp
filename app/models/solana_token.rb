# frozen_string_literal: true

# == Schema Information
#
# Table name: solana_tokens
#
#  id              :bigint           not null, primary key
#  name            :string
#  symbol          :string
#  mint_address    :string
#  decimals        :integer
#  icon_url        :string
#  website         :string
#  market_cap_rank :integer
#  price_usd       :decimal(, )
#  market_data     :json
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class SolanaToken < ApplicationRecord
  validates :name, :symbol, :mint_address, presence: true
end
