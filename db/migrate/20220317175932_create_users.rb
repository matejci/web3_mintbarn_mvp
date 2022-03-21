class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :website
      t.date :dob
      t.string :username
      t.string :display_name
      t.boolean :tos_accepted, default: false
      t.datetime :tos_accepted_at
      t.string :tos_accepted_ip
      t.boolean :admin, default: false
      t.string :password_digest
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
