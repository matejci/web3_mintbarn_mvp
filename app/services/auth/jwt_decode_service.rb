# frozen_string_literal: true

module Auth
  class JwtDecodeService
    def initialize(app_type:, token:, user_agent:, token_type:)
      @app_type = app_type
      @token = token
      @user_agent = user_agent
      @token_type = token_type
    end

    def call
      decode_token
    end

    private

    attr_reader :app_type, :token, :user_agent, :token_type

    def decode_token
      app_secret = Auth::AppSecretService.new(app_type: app_type).call
      JWT.decode(token, app_secret + user_agent, true, { algorithm: 'HS512' })
    rescue JWT::VerificationError,
           JWT::DecodeError,
           JWT::ExpiredSignature,
           JWT::ImmatureSignature,
           JWT::InvalidIssuerError,
           JWT::InvalidJtiError,
           JWT::InvalidAudError => e
      raise ActionController::BadRequest, "Invalid #{token_type} Token: #{e.message}"
    end
  end
end
