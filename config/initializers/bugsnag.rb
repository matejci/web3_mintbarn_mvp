# frozen_string_literal: true

# only run for Heroku environments
if ENV['HEROKU_ENV'].in?(%w[development production])
  Bugsnag.configure do |config|
    config.api_key = ENV['BUGSNAG_API_KEY']

    case ENV['HEROKU_ENV']
    when 'development'
      config.release_stage = 'development'
    when 'production'
      config.release_stage = 'production'
    end
  end
end
