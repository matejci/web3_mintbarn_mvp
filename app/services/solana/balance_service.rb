# frozen_string_literal: true

module Solana
  class BalanceService < BaseService
    def initialize(chain: nil)
      @chain = chain
    end

    def call
      validate_balance
    rescue StandardError => e
      handle_error(e.message, 'Solana::BalanceService', 'Insufficient balance')
    end

    private

    attr_reader :chain

    def validate_balance
      solana_client = SolanaRpcRuby::MethodsWrapper.new

      solana_client.cluster = chain.rpc_url if chain.present?

      results = solana_client.get_balance(ENV['COMPANY_PUBLIC_KEY'])
      results.parsed_response.dig('result', 'value')
    end
  end
end
