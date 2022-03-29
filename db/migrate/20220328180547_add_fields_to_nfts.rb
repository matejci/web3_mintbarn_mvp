class AddFieldsToNfts < ActiveRecord::Migration[7.0]
  def change
    add_column :nfts, :metadata_uri, :string
    add_column :nfts, :external_url, :string
  end
end
