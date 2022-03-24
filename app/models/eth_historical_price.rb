# frozen_string_literal: true

# == Schema Information
#
# Table name: eth_historical_prices
#
#  id             :bigint           not null, primary key
#  utc_date       :string
#  unix_timestamp :string
#  usd_value      :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class EthHistoricalPrice < ApplicationRecord
  validates :utc_date, uniqueness: true
end
