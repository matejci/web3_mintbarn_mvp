# == Schema Information
#
# Table name: tokens
#
#  id                :bigint           not null, primary key
#  name              :string
#  short_name        :string
#  description       :string
#  balance           :decimal(, )
#  usd_balance       :decimal(, )
#  chain_id          :bigint
#  wallet_account_id :bigint
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
require "test_helper"

class TokenTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
