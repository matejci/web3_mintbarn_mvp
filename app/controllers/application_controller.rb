# frozen_string_literal: true

# require 'jwt'

class ApplicationController < ActionController::Base
  include ErrorHandling

  protect_from_forgery with: :null_session

  before_action :validate_app_token, unless: :known_agents
  before_action :set_current_user, unless: :known_agents

  private

  def validate_app_token
    headers = request.headers

    @app = Auth::AppTokenValidationService.new(app_token: headers['APP-TOKEN'],
                                               app_id: headers['APP-ID'],
                                               app_version: headers['APP-VERSION'],
                                               user_agent: request.user_agent).call
  end

  def set_current_user
    access_token = request.headers['ACCESS-TOKEN']

    raise ActionController::BadRequest, 'Access Token missing.' if access_token.blank?

    user_session = Auth::SessionValidationService.new(access_token: access_token, app_type: @app.app_type, user_agent: request.user_agent).call

    @current_user = user_session.user
    # response.set_header('UNREAD-NOTIFICATIONS-COUNT', @current_user&.unread_notifications_count)
  end

  def user_logged_in?
    render json: { error: 'No user session' }, status: :unauthorized if @current_user.nil?
    @current_user.active?
  end

  def known_agents
    @known_agents ||= KNOWN_USER_AGENTS.find { |ua| request.user_agent.include?(ua) }
  end
end
