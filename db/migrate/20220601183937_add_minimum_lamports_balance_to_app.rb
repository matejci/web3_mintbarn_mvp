class AddMinimumLamportsBalanceToApp < ActiveRecord::Migration[7.0]
  def change
    add_column :apps, :min_mint_lamports_balance, :bigint, default: 0
    add_column :apps, :min_transfer_lamports_balance, :bigint, default: 0
  end
end
