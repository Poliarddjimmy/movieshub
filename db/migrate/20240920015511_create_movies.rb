class CreateMovies < ActiveRecord::Migration[6.1]
  def change
    create_table :movies do |t|
      t.string :title, null: false                      # Movie title
      t.text :plot                                      # Movie description
      t.text :synopsis                                  # Movie synopsis
      t.string :actors, array: true, default: []        # Array of actors in the movie
      t.integer :release_year                           # Release year of the movie
      t.string :director                                # Director of the movie
      t.string :language                                # Language the movie is in
      t.integer :duration                               # Duration in minutes
      t.integer :rating, :default => 0, :null => false  # Movie rating (e.g., PG, R)
      t.string :poster_url                              # URL for the movie poster image
      t.timestamps                                      # Automatically adds created_at and updated_at
      t.string :slug, null: false                       # URL-friendly version of the movie title
      t.integer :genres, array: true, default: []       # Array of genres for the movie
      t.boolean :is_active, default: true               # Whether the movie is active or not (i.e., published)
    end

    add_index :movies, :slug, unique: true, name: 'index_movies_on_slug'
  end
end
