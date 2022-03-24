# frozen_string_literal: true

module Cron
  class ImportEthValueJob < ApplicationJob
    queue_as :cron_jobs
    sidekiq_options retry: 1

    def perform
      import_eth_values
    rescue StandardError => e
      Bugsnag.notify(e) { |report| report.severity = 'error' }
    end

    private

    def import_eth_values
      today = Time.now.utc.to_date

      url = 'https://api.etherscan.io/api'

      query_options = { 'module' => 'stats',
                        action: 'ethdailyprice',
                        startdate: today - 3.days,
                        enddate: today,
                        apikey: ENV['ETHERSCAN_API_KEY'] }

      req = Faraday.new.get(url, query_options, {})

      return if req.status != 200

      parsed_body = JSON.parse(req.body)

      raise parsed_body['result'] if parsed_body['status'] == '0'

      parsed_body['result'].each do |record|
        EthHistoricalPrice.find_or_create_by!(utc_date: record['UTCDate'], unix_timestamp: record['unixTimeStamp'], usd_value: record['value'])
      end
    end
  end
end
