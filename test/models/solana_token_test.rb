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
#  price_ust       :decimal(, )
#  market_data     :json
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "test_helper"

class SolanaTokenTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
