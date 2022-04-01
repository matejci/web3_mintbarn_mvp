# frozen_string_literal: true

module Api
  module V1
    class NftsController < BaseController
      def create
        @collection = Nfts::CreateService.new(name: params[:name],
                                              description: params[:description],
                                              signature: params[:signature],
                                              file: params[:file],
                                              chain: @current_chain,
                                              wallet: @current_wallet).call

        render json: @collection, status: :ok
      end
    end
  end
end
