# == Schema Information
#
# Table name: sessions
#
#  id                         :bigint           not null, primary key
#  last_login                 :datetime
#  last_activity              :datetime
#  token_valid_until          :datetime
#  token_salt                 :string
#  token                      :string
#  user_agent                 :string
#  ip_address                 :string
#  live                       :boolean
#  status                     :boolean          default(TRUE)
#  player_id                  :string
#  device_name                :string
#  device_type                :string
#  device_client_name         :string
#  device_client_full_version :string
#  device_os                  :string
#  device_os_full_version     :string
#  device_known               :boolean
#  user_id                    :bigint
#  app_id                     :bigint
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
require "test_helper"

class SessionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
