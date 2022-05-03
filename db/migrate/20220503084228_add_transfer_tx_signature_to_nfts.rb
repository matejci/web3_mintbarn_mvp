class AddTransferTxSignatureToNfts < ActiveRecord::Migration[7.0]
  def change
    add_column :nfts, :transfer_tx_signature, :string
  end
end
