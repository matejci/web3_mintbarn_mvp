# frozen_string_literal: true

class NftsController < ApplicationController
  skip_before_action :validate_app_token, :set_current_wallet_account, :set_current_chain

  def show
    redirect_to('https://apps.apple.com/app/id1615549175', allow_other_host: true)
  end
end
