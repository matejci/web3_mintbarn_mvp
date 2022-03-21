class CreateSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :sessions do |t|
      t.datetime :last_login
      t.datetime :last_activity
      t.datetime :token_valid_until
      t.string :token_salt
      t.string :token
      t.string :user_agent
      t.string :ip_address
      t.boolean :live # user logged in/out
      t.boolean :status, default: true # session deactivated by admin
      t.string :player_id

      t.string :device_name
      t.string :device_type
      t.string :device_client_name
      t.string :device_client_full_version
      t.string :device_os
      t.string :device_os_full_version
      t.boolean :device_known

      t.references :user, foreign_key: true, index: true
      t.references :app, index: true

      t.timestamps
    end
  end
end
