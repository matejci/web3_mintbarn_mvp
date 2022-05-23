# == Schema Information
#
# Table name: nfts
#
#  id                          :bigint           not null, primary key
#  name                        :string
#  symbol                      :string
#  description                 :string
#  metadata                    :json
#  is_mutable                  :boolean
#  is_master_edition           :boolean          default(FALSE)
#  seller_fee_basis_points     :integer          default(0)
#  creators                    :string           is an Array
#  share                       :string           is an Array
#  mint_to_public_key          :string
#  wallet_account_id           :bigint
#  chain_id                    :bigint
#  metadata_url                :string
#  explorer_url                :string
#  mint_address                :string
#  mint_secret_recovery_phrase :string
#  primary_sale_happened       :boolean          default(FALSE)
#  transaction_signature       :string
#  update_authority            :string
#  status                      :integer          default("created")
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  price_in_lamports           :bigint
#  list_tx_signature           :string
#  transfer_tx_signature       :string
#  file_thumb_url              :string
#  list_transfer_tx_signature  :string
#  compiled_transaction        :json
#  client_listing_signed       :boolean
#  listed_at                   :datetime
#  bought_at                   :datetime
#
require "test_helper"

class NftTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
