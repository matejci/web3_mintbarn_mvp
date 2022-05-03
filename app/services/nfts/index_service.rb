# frozen_string_literal: true

module Nfts
  class IndexService
    def initialize(page:, per_page:)
      @page = page.presence || 1
      @per_page = per_page.presence || 10
    end

    def call
      nfts
    rescue StandardError => e
      error_msg = e.message
      Bugsnag.notify("NFTS::IndexService ERROR - #{error_msg}") { |report| report.severity = 'error' }
      raise ActionController::BadRequest, error_msg
    end

    private

    attr_reader :page, :per_page

    def nfts
      Nft.all.order(:created_at).offset(calculate_offset).limit(per_page)
    end

    def calculate_offset
      (page.to_i - 1) * per_page.to_i
    end
  end
end
