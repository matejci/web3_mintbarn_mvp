# frozen_string_literal: true

# == Schema Information
#
# Table name: contracts
#
#  id                       :bigint           not null, primary key
#  name                     :string
#  contract_symbol          :string
#  contract_type            :string
#  chain_id                 :bigint
#  owner_address            :string
#  metadata_updateable      :boolean          default(FALSE)
#  transaction_hash         :string
#  transaction_external_url :string
#  contract_address         :string
#  status                   :integer          default("created")
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
class Contract < ApplicationRecord
  ALLOWED_CONTRACT_TYPES = %w[erc721 erc1155].freeze

  belongs_to :chain

  enum status: { created: 0, minted: 1, completed: 2, failed: 3 }

  validates :name, :contract_symbol, :contract_type, :owner_address, presence: true
  validates :contract_type, inclusion: { in: ALLOWED_CONTRACT_TYPES }
end
