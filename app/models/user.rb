# frozen_string_literal: true

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

class User < ApplicationRecord
  has_secure_password

  # associations
  has_many :sessions, dependent: :destroy
  has_many :wallet_accounts, dependent: :destroy

  # validations
  validates :password, length: { minimum: 6 }, if: -> { password.present? }

  validates :email, uniqueness: { allow_nil: true }, format: EMAIL_REGEX, if: -> { email.present? }
  validates :phone, uniqueness: { allow_nil: true }, format: PHONE_REGEX, if: -> { phone.present? }

  with_options if: :will_save_change_to_tos_accepted? do
    validates :tos_accepted_at, :tos_accepted_ip, presence: true

    before_save :user_activation
  end

  # callbacks
  before_save :downcase_email_username, if: -> { email.present? || username.present? }

  # scopes
  scope :active, -> { where(active: true) }

  has_one_attached :profile_image do |attachable|
    attachable.variant :thumb, resize_to_limit: [250, 250]
  end

  attr_accessor :access_token

  private

  def downcase_email_username
    self.email = email&.downcase
    self.username = username&.downcase
  end

  def user_activation
    self.active = tos_accepted
  end
end
