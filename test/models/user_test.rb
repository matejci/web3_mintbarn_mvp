# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  first_name      :string
#  last_name       :string
#  email           :string
#  phone           :string
#  website         :string
#  dob             :date
#  username        :string
#  display_name    :string
#  tos_accepted    :boolean          default(FALSE)
#  tos_accepted_at :datetime
#  tos_accepted_ip :string
#  admin           :boolean          default(FALSE)
#  password_digest :string
#  active          :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
