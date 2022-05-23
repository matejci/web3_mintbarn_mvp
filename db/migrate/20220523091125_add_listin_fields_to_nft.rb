class AddListinFieldsToNft < ActiveRecord::Migration[7.0]
  def change
    add_column :nfts, :list_transfer_tx_signature, :string # used to log trasaction when doing transfer to company's wallet during listing process
    add_column :nfts, :compiled_transaction, :json
    add_column :nfts, :client_listing_signed, :boolean
    add_column :nfts, :listed_at, :datetime
    add_column :nfts, :bought_at, :datetime
  end
end
