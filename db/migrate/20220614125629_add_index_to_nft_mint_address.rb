class AddIndexToNftMintAddress < ActiveRecord::Migration[7.0]
  def change
    add_index :nfts, :mint_address
  end
end
