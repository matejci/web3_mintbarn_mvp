# frozen_string_literal: true

module Solana
  class NftActivitiesService < BaseService
    def initialize(mint_address:)
      @mint_address = mint_address
    end

    def call
      check_activities
    rescue StandardError => e
      handle_error(e.message, 'Solana::NftActivitiesService', e.message)
    end

    private

    attr_reader :mint_address

    def check_activities
      url = "https://api-mainnet.magiceden.dev/v2/tokens/#{mint_address}/activities?offset=0&limit=500"

      req = Faraday.new.get(url)

      parsed_response = JSON.parse(req.body)

      return parsed_response if req.success?

      raise ActionController::BadRequest, parsed_response['error_message']
    end
  end
end
