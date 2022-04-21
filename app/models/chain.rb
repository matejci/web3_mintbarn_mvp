# frozen_string_literal: true

# == Schema Information
#
# Table name: chains
#
#  id           :bigint           not null, primary key
#  name         :string
#  rpc_url      :string
#  explorer_url :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Chain < ApplicationRecord
  has_and_belongs_to_many :wallet_accounts
  has_many :tokens, dependent: :nullify
  has_many :nfts, dependent: :nullify
  has_many :contracts, dependent: :nullify

  validates :name, presence: true, uniqueness: true
end
