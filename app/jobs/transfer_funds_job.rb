# frozen_string_literal: true

class TransferFundsJob < ApplicationJob
  queue_as :funds_transfer
  sidekiq_options retry: 3

  def perform(nft_id)
    validate_balance
    transfer_funds(nft_id)
  rescue StandardError => e
    Bugsnag.notify(e) { |report| report.severity = 'error' }
    raise e
  end

  private

  def validate_balance
    BalanceValidationService.new(type: 'transfer').call
  end

  def transfer_funds(nft_id)
    nft = Nft.find(nft_id)

    transfer_response = Solana::TransferFundsService.new(nft: nft).call

    nft.update!(status: :funds_transferred, transfer_tx_signature: transfer_response['transaction_signature'])
  end
end
