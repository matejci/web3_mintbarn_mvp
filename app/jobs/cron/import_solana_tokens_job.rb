# frozen_string_literal: true

module Cron
  class ImportSolanaTokensJob < ApplicationJob
    queue_as :cron_jobs
    sidekiq_options retry: 1

    def perform
      import_tokens
    rescue StandardError => e
      Bugsnag.notify(e) { |report| report.severity = 'error' }
      raise e
    end

    private

    def import_tokens
      url = 'https://public-api.solscan.io/token/list'

      query_options = { sortBy: 'market_cap', direction: 'desc', limit: 10_000, offset: 0 }

      req = Faraday.new.get(url, query_options, {})

      return if req.status != 200

      parsed_body = JSON.parse(req.body)

      parsed_body['data'].each do |item|
        token = SolanaToken.find_or_create_by!(name: item['tokenName'], symbol: item['tokenSymbol'], mint_address: item['mintAddress'])
        token.update!(decimals: item['decimals'],
                      icon_url: item['icon'],
                      website: item['website'],
                      market_cap_rank: item['marketCapRank'],
                      price_ust: item['priceUst'],
                      market_data: item.dig('coingeckoInfo', 'marketData'))
      end
    end
  end
end
