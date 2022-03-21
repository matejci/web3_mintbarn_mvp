# frozen_string_literal: true

module Auth
  class LoginService
    def initialize(id:, password:)
      @id = id
      @password = password
    end

    def call
      login_user
    end

    private

    attr_reader :id, :password

    def login_user
      raise ActionController::ParameterMissing, 'Missing login email/phone/username.' if id.blank?

      login_key, login_id = if id.starts_with?('+')
        [:phone, id]
      elsif id.include?('@')
        [:email, id.downcase]
      else
        [:username, id.downcase]
      end

      user = User.active.find_by(login_key => login_id)

      raise ActionController::BadRequest, 'User not found' if user.nil?
      raise ActionController::BadRequest, 'Authentication failed' unless user.authenticate(password)

      user
    end
  end
end
