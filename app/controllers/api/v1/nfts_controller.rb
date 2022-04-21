# frozen_string_literal: true

module Api
  module V1
    class NftsController < BaseController
      def create
        @nft = Nfts::CreateService.new(params: params, chain: @current_chain, wallet: @current_wallet).call

        render :create, status: :created
      end
    end
  end
end
