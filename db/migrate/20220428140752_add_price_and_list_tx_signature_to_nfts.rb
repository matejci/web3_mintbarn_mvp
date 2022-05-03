class AddPriceAndListTxSignatureToNfts < ActiveRecord::Migration[7.0]
  def change
    add_column :nfts, :price_in_lamports, :bigint
    add_column :nfts, :list_tx_signature, :string
  end
end
