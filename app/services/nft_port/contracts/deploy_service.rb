# frozen_string_literal: true

# TODO, adjust and refactor this once ready for prod
# You can deploy up to 5 contracts for free per chain
module NftPort
  module Contracts
    class DeployService < BaseService
      def initialize(contract:, chain_name:)
        @contract = contract
        @chain_name = chain_name
      end

      def call
        deploy_contract
      rescue StandardError => e
        Bugsnag.notify("NftPort::Contracts::DeployService ERROR - #{e.message}") { |report| report.severity = 'error' }
        raise e
      end

      private

      attr_reader :contract, :chain_name

      def deploy_contract
        url = 'https://api.nftport.xyz/v0/contracts'

        req_body = {
          chain: Chains::MapperService.new(chain_name: chain_name).call,
          name: contract.name,
          symbol: contract.contract_symbol,
          owner_address: contract.owner_address,
          metadata_updateable: contract.metadata_updateable,
          type: contract.contract_type
        }

        req = Faraday.new.post(url, req_body.to_json, nft_port_headers)

        parsed_response = JSON.parse(req.body)

        if req.status != 200 || parsed_response['response'] == 'NOK'
          contract.status = :failed
          contract.save!
          return { error: parsed_response['error'] }
        end

        contract.transaction_hash = parsed_response['transaction_hash']
        contract.transaction_external_url = parsed_response['transaction_external_url']
        contract.status = :minted
        contract.save!

        UpdateContractAddressJob.set(wait: 2.minutes).perform_later(contract_id: contract.id)

        { contract: contract }
      end
    end
  end
end
