class AddEtherscanApiUrlToChains < ActiveRecord::Migration[7.0]
  def change
    add_column :chains, :etherscan_api_url, :string
  end
end
