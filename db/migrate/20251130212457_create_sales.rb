class CreateSales < ActiveRecord::Migration[8.1]
  def change
    create_table :sales do |t|
      t.datetime :sale_date
      t.string :buyer_name
      t.string :buyer_contact
      t.decimal :total
      t.boolean :cancelled, default: false
      t.timestamps
    end
  end
end
