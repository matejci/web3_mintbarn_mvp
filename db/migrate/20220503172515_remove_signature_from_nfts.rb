class RemoveSignatureFromNfts < ActiveRecord::Migration[7.0]
  def change
    remove_column :nfts, :signature
  end
end
