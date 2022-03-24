class CreateEthHistoricalPrices < ActiveRecord::Migration[7.0]
  def change
    create_table :eth_historical_prices do |t|
      t.string :utc_date
      t.string :unix_timestamp
      t.string :usd_value
      t.timestamps
    end

    add_index :eth_historical_prices, :utc_date, unique: true
  end
end
