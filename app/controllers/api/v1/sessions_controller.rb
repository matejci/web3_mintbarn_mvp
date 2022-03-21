# frozen_string_literal: true

module Api
  module V1
    class SessionsController < BaseController
      skip_before_action :set_current_user

      def create
        user = Auth::LoginService.new(id: params[:id], password: params[:password]).call
        prepare_session(user)
        render :create, status: :created
      end

      private

      def prepare_session(user)
        @current_user = user

        session = Auth::HandleSessionService.new(user: user,
                                                 player_id: request.headers['PLAYER-ID'],
                                                 user_agent: request.user_agent,
                                                 app: @app,
                                                 ip_address: request.remote_ip).call

        @current_user.access_token = session.token
      end
    end
  end
end
