# frozen_string_literal: true

# == Schema Information
#
# Table name: tokens
#
#  id                :bigint           not null, primary key
#  name              :string
#  short_name        :string
#  description       :string
#  balance           :decimal(, )
#  usd_balance       :decimal(, )
#  chain_id          :bigint
#  wallet_account_id :bigint
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Token < ApplicationRecord
  belongs_to :chain, inverse_of: :tokens
  belongs_to :wallet_account

  validates :name, :short_name, presence: true
  validates :name, uniqueness: { scope: [:chain_id, :wallet_account_id] }
end
