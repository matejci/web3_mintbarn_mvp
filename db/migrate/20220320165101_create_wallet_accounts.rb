class CreateWalletAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :wallet_accounts do |t|
      t.string :wallet_name
      t.string :account_name
      t.string :address
      t.references :user, index: true # We don't need FK at the moment
      t.timestamps
    end
  end
end
