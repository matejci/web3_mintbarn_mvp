# frozen_string_literal: true

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
#
class Nft < ApplicationRecord
  belongs_to :wallet_account
  belongs_to :chain

  # TODO, file validations!
  has_one_attached :file

  enum status: { created: 0, minted: 1, failed: 2 }

  validates :name, :description, presence: true

  validates :name, length: { minimum: 1, maximum: 400 }
  validates :description, length: { minimum: 1, maximum: 2000 }
end
