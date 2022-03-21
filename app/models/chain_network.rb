# frozen_string_literal: true

# == Schema Information
#
# Table name: chain_networks
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ChainNetwork < ApplicationRecord
  has_and_belongs_to_many :wallet_accounts
  has_many :tokens, dependent: :nullify

  validates :name, presence: true, uniqueness: true
end
