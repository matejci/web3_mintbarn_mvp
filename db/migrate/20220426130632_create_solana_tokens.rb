class CreateSolanaTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :solana_tokens do |t|
      t.string :name
      t.string :symbol
      t.string :mint_address
      t.integer :decimals
      t.string :icon_url
      t.string :website
      t.integer :market_cap_rank
      t.decimal :price_usd
      t.json :market_data

      t.timestamps
    end
  end
end
