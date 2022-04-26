# frozen_string_literal: true

module Api
  module V1
    class SolanaTokensController < BaseController
      skip_before_action :set_current_wallet_account, :set_current_chain

      def index
        @token = SolanaToken.where('symbol ILIKE ?', params[:token_symbol]).first

        raise ActionController::BadRequest, 'Token not found' unless @token
      end
    end
  end
end
