# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :validate_app_token, :set_current_wallet_account

  def index
    render plain: 'My NFT Stats - Coming soon'
  end
end
