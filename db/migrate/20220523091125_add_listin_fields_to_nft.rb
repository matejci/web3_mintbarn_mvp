class AddListinFieldsToNft < ActiveRecord::Migration[7.0]
  def change
    add_column :nfts, :listed_at, :datetime
    add_column :nfts, :bought_at, :datetime
  end
end
