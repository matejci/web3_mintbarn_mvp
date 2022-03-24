# frozen_string_literal: true

module Metrics
  class IndexService
    def initialize(wallet:, type:, period:)
      @wallet = wallet
      @type = type
      @period = period.presence || '7_days'
    end

    def call
      metrics
    end

    private

    attr_reader :wallet, :type, :period

    def metrics
      []
    end
  end
end
