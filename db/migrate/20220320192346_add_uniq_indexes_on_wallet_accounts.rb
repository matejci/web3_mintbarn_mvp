class AddUniqIndexesOnWalletAccounts < ActiveRecord::Migration[7.0]
  def change
    add_index :wallet_accounts, [:account_name, :wallet_name], unique: true
    add_index :wallet_accounts, :address, unique: true
  end
end
