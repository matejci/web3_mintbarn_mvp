# frozen_string_literal: true

module Api
  module V1
    class NftsController < BaseController
      skip_before_action :set_current_wallet_account, :set_current_chain, only: :show
      before_action :find_nft, only: [:show, :list]

      def create
        @nft = Nfts::CreateService.new(params: params, chain: @current_chain, wallet: @current_wallet).call

        render :create, status: :created
      end

      def index
        @collection = Nfts::IndexService.new(page: params[:page], per_page: params[:per_page], wallet: @current_wallet, chain: @current_chain).call
      end

      def show; end

      def list
        compiled_transaction = Nfts::ListService.new(nft: @nft,
                                                     wallet_address: @current_wallet.address,
                                                     chain_name: @current_chain.name.downcase,
                                                     price: params[:price_in_lamports]).call

        render json: { data: compiled_transaction }, status: :ok
      end

      private

      def find_nft
        @nft = Nft.find(params[:id])
      end
    end
  end
end
