class AddTokenIdAndMintTypeToNfts < ActiveRecord::Migration[7.0]
  def change
    add_column :nfts, :token_id, :string
    add_column :nfts, :mint_type, :string
  end
end
