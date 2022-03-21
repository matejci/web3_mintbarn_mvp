# frozen_string_literal: true

module Auth
  class AppSecretService
    def initialize(app_type:)
      @app_type = app_type
    end

    def call
      app_secret
    end

    private

    attr_reader :app_type

    def app_secret
      case app_type
      when 'ios'
        ENV['JWT_APP_SECRET']
      end
    end
  end
end
