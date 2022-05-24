# frozen_string_literal: true

module Solana
  class BaseService
    def initialize
      raise 'Implement in child class!'
    end

    private

    def handle_error(bugsnag_err, service, raise_msg)
      Bugsnag.notify("#{service} ERROR - #{bugsnag_err}") { |report| report.severity = 'error' }
      raise ActionController::BadRequest, "Service: #{service} - ERROR: #{raise_msg}"
    end

    def handle_http_request(url:, method:, payload:, headers: nil)
      req_headers = { 'content-type': 'application/json', APIKeyID: ENV['BLOCKCHAIN_API_KEY_ID'], APISecretKey: ENV['BLOCKCHAIN_SECRET_KEY'] }
      req_headers.merge!(headers) if headers

      req = Faraday.new.send(method, url, payload, req_headers)

      parsed_response = JSON.parse(req.body)

      return parsed_response if req.success?

      raise ActionController::BadRequest, parsed_response['error_message']
    end
  end
end
