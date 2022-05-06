# frozen_string_literal: true

class NftsController < ApplicationController
  skip_before_action :validate_app_token, :set_current_wallet_account, :set_current_chain

  def show
    @nft = Nft.find(params[:id])
  end
end
