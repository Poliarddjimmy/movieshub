class CreateSeasons < ActiveRecord::Migration[7.0]
  def change
    create_table :seasons do |t|
      t.references :movie, null: false, foreign_key: true
      t.string :season_number, null: false
      t.string :title, null: false
      t.text :description

      t.timestamps
    end

    add_index :seasons, [:movie_id, :season_number], unique: true
  end
end
