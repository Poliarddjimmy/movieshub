class CreateEpisodes < ActiveRecord::Migration[6.1]
  def change
    create_table :episodes do |t|
      t.references :season, null: false, foreign_key: true
      t.integer :episode_number, null: false
      t.string :title, null: false
      t.text :description
      t.integer :duration, null: false
      t.string :video_url, null: false

      t.timestamps
    end

    add_index :episodes, [:season_id, :episode_number], unique: true
  end
end
