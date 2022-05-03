class RenameMintToMintAddress < ActiveRecord::Migration[7.0]
  def change
    rename_column :nfts, :mint, :mint_address
  end
end
