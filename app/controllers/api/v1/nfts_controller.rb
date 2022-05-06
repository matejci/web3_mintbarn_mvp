# frozen_string_literal: true

module Api
  module V1
    class NftsController < BaseController
      skip_before_action :set_current_wallet_account, :set_current_chain, only: :show

      def create
        @nft = Nfts::CreateService.new(params: params, chain: @current_chain, wallet: @current_wallet).call

        render :create, status: :created
      end

      def index
        @collection = Nfts::IndexService.new(page: params[:page], per_page: params[:per_page], wallet: @current_wallet).call
      end

      def show
        @nft = Nft.find(params[:id])
      end
    end
  end
end
