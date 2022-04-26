class CreateNfts < ActiveRecord::Migration[7.0]
  def change
    create_table :nfts do |t|
      t.string :signature
      t.string :name
      t.string :symbol
      t.string :description
      t.json :metadata
      t.boolean :is_mutable
      t.boolean :is_master_edition, default: false
      t.integer :seller_fee_basis_points, default: 0
      t.string :creators, array: true
      t.string :share, array: true
      t.string :mint_to_public_key

      t.references :wallet_account, foreign_key: true, index: true
      t.references :chain, foreign_key: true, index: true

      t.string :metadata_url
      t.string :explorer_url
      t.string :mint
      t.string :mint_secret_recovery_phrase
      t.boolean :primary_sale_happened, default: false
      t.string :transaction_signature
      t.string :update_authority

      t.integer :status, default: 0
      t.timestamps
    end

    add_index :nfts, :creators, using: 'gin'
    add_index :nfts, :share, using: 'gin'
  end
end
