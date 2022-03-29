class CreateContracts < ActiveRecord::Migration[7.0]
  def change
    create_table :contracts do |t|
      t.string :name
      t.string :contract_symbol
      t.string :contract_type
      t.references :chain, foreign_key: true, index: true
      t.string :owner_address
      t.boolean :metadata_updateable, default: false
      t.string :transaction_hash
      t.string :transaction_external_url
      t.string :contract_address
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
