class AddAlbumToSaleItems < ActiveRecord::Migration[8.1]
  def change
    add_reference :sale_items, :album, null: false, foreign_key: true
  end
end
