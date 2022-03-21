# frozen_string_literal: true

module Auth
  class AppTokenValidationService
    def initialize(app_token:, app_id:, app_version:, user_agent:)
      @app_token = app_token
      @app_id = app_id
      @app_version = app_version
      @user_agent = user_agent
    end

    def call
      validate_app_token
    end

    private

    attr_reader :app_token, :app_id, :app_version, :user_agent

    def validate_app_token
      app = App.active.find_by(app_id: app_id)

      raise ActionController::BadRequest, 'Invalid APP ID' unless app
      raise ActionController::BadRequest, 'Wrong APP version' unless version_supported?(app)

      decoded_token = Auth::JwtDecodeService.new(app_type: app.app_type, token: app_token, user_agent: user_agent, token_type: 'APP').call

      app_query = App.active.find_by(app_id: decoded_token.dig(0, 'app_id'), public_key: decoded_token.dig(0, 'public_key'))

      raise ActionController::BadRequest, 'Wrong APP Token' unless app_query

      app_query
    end

    def version_supported?(app)
      return true if ENV.fetch('HEROKU_ENV', nil) != 'production'

      app.supported_versions.include?(app_version)
    end
  end
end
