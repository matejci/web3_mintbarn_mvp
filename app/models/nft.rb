# frozen_string_literal: true

# == Schema Information
#
# Table name: nfts
#
#  id                          :bigint           not null, primary key
#  signature                   :string
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
#  mint                        :string
#  mint_secret_recovery_phrase :string
#  primary_sale_happened       :boolean          default(FALSE)
#  transaction_signature       :string
#  update_authority            :string
#  status                      :integer          default("created")
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
class Nft < ApplicationRecord
  belongs_to :wallet_account
  belongs_to :chain

  # TODO, file validations!
  has_one_attached :file

  enum status: { created: 0, metadata_uploaded: 1, minted: 2, failed: 3 }

  validates :name, presence: true, length: { maximum: 32 }
  validates :symbol, length: { maximum: 10 }
  validates :description, length: { maximum: 2000 }
  validates :seller_fee_basis_points, numericality: { in: 0..10_000 }
  validates :creators, :share, presence: true
end
