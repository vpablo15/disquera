class AddBuyerIdToSales < ActiveRecord::Migration[8.1]
  def change
    add_column :sales, :buyer_id, :string
  end
end
