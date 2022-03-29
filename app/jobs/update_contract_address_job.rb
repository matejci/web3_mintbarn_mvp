# frozen_string_literal: true

class UpdateContractAddressJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 5

  def perform(contract_id:)
    @contract_id = contract_id

    update_contract_address
  rescue StandardError => e
    Bugsnag.notify(e.message) { |report| report.severity = 'error' }
    raise e
  end

  private

  attr_reader :contract_id

  def update_contract_address
    contract = Contract.find(contract_id)

    NftPort::Contracts::RetrieveDeployedContractService.new(contract: contract).call
  end
end
