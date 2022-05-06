# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :validate_app_token, :set_current_wallet_account, :set_current_chain

  def index
    render plain: 'My NFT Stats - Coming soon'
  end

  def aasa
    @apple_apps = {
      applinks: {
        details: [
          {
            appIDs: [ENV['APPLE_APP_ID']],
            components: [
              {
                '/': '/phantomRedirect/*'
              },
              {
                '/': '/nfts/*'
              }
            ]
          }
        ]
      }
    }
  end
end
