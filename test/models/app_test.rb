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
require "test_helper"

class AppTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
