# == Schema Information
#
# Table name: nfts
#
#  id                       :bigint           not null, primary key
#  name                     :string
#  description              :string
#  wallet_account_id        :bigint
#  chain_id                 :bigint
#  status                   :integer          default("created")
#  contract_address         :string
#  transaction_hash         :string
#  transaction_external_url :string
#  mint_error               :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  metadata_uri             :string
#  external_url             :string
#
require "test_helper"

class NftTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
