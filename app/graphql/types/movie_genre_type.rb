module Types
  class MovieGenreType < Types::BaseObject
    field :id, ID, null: false
    field :movie, Types::MovieType, null: false
    field :genre, Types::GenreType, null: false
  end
end
