class CreateSaleItems < ActiveRecord::Migration[8.1]
  def change
    create_table :sale_items do |t|
      t.references :sale, null: false, foreign_key: true
      t.string :product_name
      t.integer :quantity
      t.decimal :price

      t.timestamps
    end
  end
end
