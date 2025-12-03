class RemoveCategoryAndAddGenreToAlbums < ActiveRecord::Migration[8.1]
  def change
    # 1. Quitar la columna 'category'
    remove_column :albums, :category, :string
    
    # 2. Añadir la nueva columna 'genre_id' (clave foránea)
    add_reference :albums, :genre, null: false, foreign_key: true
  end
end
