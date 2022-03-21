# frozen_string_literal: true

# == Schema Information
#
# Table name: apps
#
#  id                 :bigint           not null, primary key
#  app_id             :string
#  app_type           :string
#  name               :string
#  description        :string
#  status             :boolean          default(TRUE)
#  supported_versions :string           is an Array
#  public_key         :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class App < ApplicationRecord
  scope :active, -> { where(status: true) }
end
