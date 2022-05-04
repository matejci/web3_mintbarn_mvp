class AddFileThumbUrlToNfts < ActiveRecord::Migration[7.0]
  def change
    add_column :nfts, :file_thumb_url, :string
  end
end
