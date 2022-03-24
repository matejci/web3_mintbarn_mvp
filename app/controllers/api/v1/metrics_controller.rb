# frozen_string_literal: true

module Api
  module V1
    class MetricsController < BaseController
      def index
        @collection = Metrics::IndexService.new(wallet: @current_wallet, type: params[:type], period: params[:period]).call
      end

      # # Value of NFTs + ETH on a certain day
      # def total_value
      # end

      # def floor_value; end

      # # Get a list of 'Normal' Transactions By Address
      # def total_eth_in; end

      # # Get a list of 'Normal' Transactions By Address
      # def total_eth_out; end
    end
  end
end
