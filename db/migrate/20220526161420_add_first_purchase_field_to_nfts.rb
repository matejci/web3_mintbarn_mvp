class AddFirstPurchaseFieldToNfts < ActiveRecord::Migration[7.0]
  def change
    add_column :nfts, :first_purchase, :json
  end
end
