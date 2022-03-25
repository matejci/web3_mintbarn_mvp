# frozen_string_literal: true

module Minerstat
  class WalletAddressValidatorService
    def initialize(address:)
      @address = address
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
