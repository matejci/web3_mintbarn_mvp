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
#  metadata_uri             :string
#  external_url             :string
#  signature                :string
#  token_id                 :string
#  mint_type                :string
#
class Nft < ApplicationRecord
  MINT_TYPES = %w[lazy normal].freeze

  belongs_to :wallet_account
  belongs_to :chain

  # TODO, file validations!
  has_one_attached :file

  enum status: { created: 0, metadata_uploaded: 1, minted: 2, failed: 3, waiting_on_signing: 4 }

  validates :name, :description, :mint_type, presence: true
  validates :mint_type, inclusion: { in: MINT_TYPES }
  validates :name, length: { minimum: 1, maximum: 400 }
  validates :description, length: { minimum: 1, maximum: 2000 }

  validates :signature, presence: true, if: -> { mint_type == 'normal' }
end
