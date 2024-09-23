class MovieGenre < ApplicationRecord
  belongs_to :movie
  belongs_to :genre

  # Ensure that the combination of movie and genre is unique
  validates :movie_id, uniqueness: { scope: :genre_id, message: "Movie can only be assigned to this genre once" }

  # Ensure movie and genre exist
  validates :movie, presence: true
  validates :genre, presence: true
end
