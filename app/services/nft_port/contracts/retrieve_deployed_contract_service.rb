# frozen_string_literal: true

module NftPort
  module Contracts
    class RetrieveDeployedContractService < BaseService
      def initialize(contract:)
        @contract = contract
      end

      def call
        fetch_contract_info
      rescue StandardError => e
        Bugsnag.notify(e.message) { |report| report.severity = 'error' }
        raise e
      end

      private

      attr_reader :contract

      def fetch_contract_info
        chain = Chains::MapperService.new(chain_name: contract.chain.name).call

        url = "https://api.nftport.xyz/v0/contracts/#{contract.transaction_hash}?chain=#{chain}"

        req = Faraday.new.get(url, nil, nft_port_headers)

        parsed_response = JSON.parse(req.body)

        if req.status != 200 || parsed_response['response'] == 'NOK'
          contract.status = :failed
          contract.save!
          raise parsed_response['error']
        end

        contract.contract_address = parsed_response['contract_address']
        contract.status = :completed
        contract.save!
      end
    end
  end
end
