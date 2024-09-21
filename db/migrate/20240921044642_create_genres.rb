class CreateGenres < ActiveRecord::Migration[7.0]
  def change
    create_table :genres do |t|
      t.string :name
      t.text :description
      t.string :slug
      t.integer :popularity
      t.boolean :is_active, :default => false, :null => false
      t.string :image_url

      t.timestamps
    end

    add_index :genres, :name, unique: true      # Ensure genre names are unique
    add_index :genres, :slug, unique: true      # Ensure slug is unique
  end
end
