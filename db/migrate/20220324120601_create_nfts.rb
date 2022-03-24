class CreateNfts < ActiveRecord::Migration[7.0]
  def change
    create_table :nfts do |t|
      t.string :name
      t.string :description
      t.references :wallet_account, foreign_key: true, index: true
      t.references :chain, foreign_key: true, index: true
      t.integer :status, default: 0
      t.string :contract_address
      t.string :transaction_hash
      t.string :transaction_external_url
      t.string :mint_error
      t.timestamps
    end
  end
end
