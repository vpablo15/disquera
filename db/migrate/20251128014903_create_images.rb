class CreateImages < ActiveRecord::Migration[8.1]
  def change
    create_table :images do |t|
      t.references :album, null: false, foreign_key: true
      t.boolean :is_cover
      t.string :title
      t.string :short_description

      t.timestamps
    end
  end
end
