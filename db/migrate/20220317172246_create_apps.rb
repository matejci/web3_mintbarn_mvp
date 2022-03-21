class CreateApps < ActiveRecord::Migration[7.0]
  def change
    create_table :apps do |t|
      t.string :app_id, index: true
      t.string :app_type
      t.string :name
      t.string :description
      t.boolean :status, default: true
      t.string :supported_versions, array: true
      t.string :public_key
      t.timestamps
    end
  end
end
