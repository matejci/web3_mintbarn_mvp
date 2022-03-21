class AddChainNetworkWalletAccountsJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_table :chain_networks_wallet_accounts, id: false do |t|
      t.bigint :chain_network_id
      t.bigint :wallet_account_id
      t.timestamps
    end
  end
end
