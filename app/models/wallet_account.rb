# frozen_string_literal: true

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
class WalletAccount < ApplicationRecord
  belongs_to :user, optional: true # for now, this is optional. once we introduce Users and connect it with WalletAccount, then add FK user_id
  has_and_belongs_to_many :chains
  has_many :nfts, dependent: :nullify

  # validates :wallet_name, :account_name, :address, presence: true
  validates :wallet_name, :address, presence: true
  validates :account_name, uniqueness: { scope: :wallet_name }, allow_nil: true
  validates :address, uniqueness: true
end
