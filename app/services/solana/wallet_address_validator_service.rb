# frozen_string_literal: true

module Solana
  class WalletAddressValidatorService
    def initialize(address:)
      @address = address
    end

    def call
      validate_address
    rescue StandardError => e
      Bugsnag.notify("Solana::WalletAddressValidatorService ERROR - #{e.message}") { |report| report.severity = 'error' }
      raise ActionController::BadRequest, 'Wallet address invalid'
    end

    private

    attr_reader :address

    def validate_address
      solana_client = SolanaRpcRuby::MethodsWrapper.new
      results = solana_client.get_account_info(address)
      results.parsed_response.dig('result', 'context').present?
    end
  end
end
