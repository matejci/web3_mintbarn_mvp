# frozen_string_literal: true

class BalanceValidationService
  ALLOWED_TYPES = %w[mint transfer].freeze

  def initialize(type:)
    @type = type
  end

  def call
    validate_type
    validate_balance
  end

  private

  attr_reader :type

  def validate_type
    raise 'Wrong balance validation type' unless type.in?(ALLOWED_TYPES)
  end

  def validate_balance
    balance = Solana::BalanceService.new.call

    raise 'Insufficient balance' if balance <= App.ios_minimum_lamports_balance(type)
  end
end
