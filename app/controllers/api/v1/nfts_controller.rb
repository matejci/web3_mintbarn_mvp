# frozen_string_literal: true

module Api
  module V1
    class NftsController < BaseController
      def create
        @collection = Nfts::CreateService.new(name: params[:name],
                                              description: params[:description],
                                              signature: params[:signature],
                                              file: params[:file],
                                              mint_type: params[:mint_type],
                                              chain: @current_chain,
                                              wallet: @current_wallet).call

        render json: @collection, status: :ok
      end

      def lazy_mint_sign
        @collection = Rarible::Nfts::LazyMintSignService.new(nft_id: params[:nft_id],
                                                             signature: params[:signature],
                                                             creators: params[:creators],
                                                             royalties: params[:royalties],
                                                             chain_name: @current_chain.name.downcase.to_sym,
                                                             owner_address: @current_wallet.address).call

        render json: @collection, status: :ok
      end
    end
  end
end
