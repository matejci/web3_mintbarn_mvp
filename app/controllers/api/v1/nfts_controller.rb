# frozen_string_literal: true

module Api
  module V1
    class NftsController < BaseController
      skip_before_action :set_current_wallet_account, :set_current_chain, only: :show
      before_action :find_nft, only: :show

      def create
        @nft = Nfts::CreateService.new(params: params, chain: @current_chain, wallet: @current_wallet).call

        render :create, status: :created
      end

      def index
        @collection = Nfts::IndexService.new(page: params[:page], per_page: params[:per_page], wallet: @current_wallet, chain: @current_chain).call
      end

      def show; end

      private

      def find_nft
        @nft = Nft.find(params[:id])
        raise ActionController::BadRequest, 'Nft is archived' if @nft.status == 'archived'
      end
    end
  end
end
