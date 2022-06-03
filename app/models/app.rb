# frozen_string_literal: true

# == Schema Information
#
# Table name: apps
#
#  id                            :bigint           not null, primary key
#  app_id                        :string
#  app_type                      :string
#  name                          :string
#  description                   :string
#  status                        :boolean          default(TRUE)
#  supported_versions            :string           is an Array
#  public_key                    :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  min_mint_lamports_balance     :bigint           default(0)
#  min_transfer_lamports_balance :bigint           default(0)
#
class App < ApplicationRecord
  scope :active, -> { where(status: true) }
  scope :ios, -> { where(app_type: 'ios') }

  def self.ios_minimum_lamports_balance(type)
    Rails.cache.fetch("min_#{type}_lamports_balance") do
      active.ios.first.send("min_#{type}_lamports_balance")
    end
  end
end
