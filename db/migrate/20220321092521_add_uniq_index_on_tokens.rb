class AddUniqIndexOnTokens < ActiveRecord::Migration[7.0]
  def change
    add_index :tokens, [:name, :chain_id, :wallet_account_id], unique: true
  end
end
