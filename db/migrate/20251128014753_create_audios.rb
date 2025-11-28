class CreateAudios < ActiveRecord::Migration[8.1]
  def change
    create_table :audios do |t|
      t.references :album, null: false, foreign_key: true

      t.timestamps
    end
  end
end
