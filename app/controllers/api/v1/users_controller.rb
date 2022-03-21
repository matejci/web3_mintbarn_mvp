# frozen_string_literal: true

module Api
  module V1
    class UsersController < BaseController
      before_action :user_logged_in?

      def profile; end
    end
  end
end
