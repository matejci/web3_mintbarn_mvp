# frozen_string_literal: true

# WIP
class UpdateBalanceJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 1

  def perform(wallet_id)
    @wallet_id = wallet_id

    update_balance
  rescue StandardError => e
    Rails.logger.error(e.message)
  end

  private

  attr_reader :wallet_id

  def update_balance
    wa = WalletAccount.find(wallet_id)

    url = 'https://api-rinkeby.etherscan.io/api'

    query_options = { 'module' => 'account',
                      action: 'balance',
                      address: wa.address,
                      tag: 'latest',
                      apikey: ENV['ETHERSCAN_API_KEY'] }

    req = Faraday.new.get(url, query_options, {})

    return if req.status != 200

    response = JSON.parse(req.body)
    wei_balance = response['result']
    _eth_balance = wei_balance.to_i / 1e18
  end
end
