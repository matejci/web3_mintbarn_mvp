class CreateTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :tokens do |t|
      t.string :name
      t.string :short_name
      t.string :description
      t.decimal :balance
      t.decimal :usd_balance
      t.references :chain, foreign_key: true, index: true
      t.references :wallet_account, foreign_key: true, index: true
      t.timestamps
    end
  end
end
