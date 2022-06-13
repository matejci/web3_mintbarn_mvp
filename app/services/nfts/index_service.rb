# frozen_string_literal: true

module Nfts
  class IndexService
    def initialize(page:, per_page:, wallet:, chain:)
      @page = page.presence || 1
      @per_page = (per_page.presence || 10).to_i
      @wallet = wallet
      @chain = chain
    end

    def call
      nfts
    rescue StandardError => e
      error_msg = e.message
      Bugsnag.notify("NFTS::IndexService ERROR - #{error_msg}") { |report| report.severity = 'error' }
      raise ActionController::BadRequest, error_msg
    end

    private

    attr_reader :page, :per_page, :wallet, :chain

    def nfts
      data = wallet.nfts.where(chain_id: chain.id).where.not(status: :archived).order(:created_at).offset(calculate_offset).limit(per_page)

      { data: data, total_pages: calculate_total_pages }
    end

    def calculate_offset
      (page.to_i - 1) * per_page
    end

    def calculate_total_pages
      nfts_count = wallet.nfts.size

      (nfts_count % per_page).zero? ? (nfts_count / per_page) : ((nfts_count / per_page) + 1)
    end
  end
end
