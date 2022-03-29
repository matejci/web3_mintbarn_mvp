# frozen_string_literal: true

module Minerstat
  class WalletAddressValidatorService
    def initialize(address:)
      @address = address
    rescue StandardError => e
      Bugsnag.notify("Minerstat::WalletAddressValidatorService ERROR - #{e.message}") { |report| report.severity = 'error' }
      raise e
    end

    def call
      validate_address
    end

    private

    attr_reader :address

    def validate_address
      url = 'https://minerstat.com/wallet-address-validator/ethereum'

      req = Faraday.new.post(url, { check: address }, { 'content-type': 'application/x-www-form-urlencoded; charset=UTF-8' })

      req.body.include?('looks valid')
    end
  end
end
