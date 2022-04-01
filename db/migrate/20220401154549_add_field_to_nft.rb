class AddFieldToNft < ActiveRecord::Migration[7.0]
  def change
    add_column :nfts, :signature, :string
  end
end
