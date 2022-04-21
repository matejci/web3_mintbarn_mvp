class CreateChains < ActiveRecord::Migration[7.0]
  def change
    create_table :chains do |t|
      t.string :name
      t.string :rpc_url
      t.string :explorer_url
      t.timestamps
    end

    add_index :chains, :name, unique: true
  end
end
