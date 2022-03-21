class CreateChainNetworks < ActiveRecord::Migration[7.0]
  def change
    create_table :chain_networks do |t|
      t.string :name
      t.timestamps
    end

    add_index :chain_networks, :name, unique: true
  end
end
