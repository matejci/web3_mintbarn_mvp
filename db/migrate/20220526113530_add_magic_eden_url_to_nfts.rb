class AddMagicEdenUrlToNfts < ActiveRecord::Migration[7.0]
  def change
    add_column :nfts, :magic_eden_url, :string
  end
end
