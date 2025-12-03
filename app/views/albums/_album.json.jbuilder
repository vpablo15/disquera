json.extract! album, :id, :name, :description, :unit_price, :stock_available, :genre_id, :media_type, :condition_is_new, :author_id, :deleted_at, :created_at, :updated_at
json.url album_url(album, format: :json)
