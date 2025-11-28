class CreateAlbums < ActiveRecord::Migration[8.1]
  def change
    create_table :albums do |t|
      t.string :name
      t.text :description
      t.decimal :unit_price
      t.integer :stock_available
      t.string :category
      t.string :media_type
      t.boolean :condition_is_new
      t.references :author, null: false, foreign_key: true
      t.date :deleted_at

      t.timestamps
    end
  end
end
