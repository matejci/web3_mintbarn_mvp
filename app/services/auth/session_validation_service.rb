# frozen_string_literal: true

module Auth
  class SessionValidationService
    def initialize(access_token:, app_type:, user_agent:)
      @access_token = access_token
      @app_type = app_type
      @user_agent = user_agent
    end

    def call
      validate_session
    end

    private

    attr_reader :access_token, :app_type, :user_agent

    def validate_session
      decoded_token = Auth::JwtDecodeService.new(app_type: app_type, token: access_token, user_agent: user_agent, token_type: 'ACCESS').call

      session = Session.find_by(token_salt: decoded_token.dig(0, 'access_token'))

      raise ActionController::BadRequest, 'Unauthorized' unless session
      raise ActionController::BadRequest, 'Invalid or inactive session' unless session.valid? && session.status == true

      session.last_activity = Time.current
      session.live = true
      session.save
      session
    end
  end
end
