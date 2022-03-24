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
require "test_helper"

class EthHistoricalPriceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
