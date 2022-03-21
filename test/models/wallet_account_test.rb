# == Schema Information
#
# Table name: wallet_accounts
#
#  id           :bigint           not null, primary key
#  wallet_name  :string
#  account_name :string
#  address      :string
#  user_id      :bigint
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require "test_helper"

class WalletAccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
