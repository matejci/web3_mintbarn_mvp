# frozen_string_literal: true

module EthereumConvertorService
  def self.eth_to_wei(eth)
    (eth * 1e18).to_i
  end

  def self.wei_to_eth(wei)
    (BigDecimal(wei, 16) / BigDecimal(1e18.to_s, 16)).to_f
  end
end
