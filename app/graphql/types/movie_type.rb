# app/graphql/types/movie_type.rb
module Types
  class MovieType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :plot, String, null: true
    field :synopsis, String, null: true
    field :actors, [String], null: true
    field :release_year, Integer, null: true
    field :director, String, null: true
    field :language, String, null: true
    field :duration, Integer, null: true
    field :rating, Integer, null: true
    field :poster_url, String, null: true
    field :slug, String, null: false
    field :genres, [Types::GenreType], null: true
    field :movie_genres, [Types::MovieGenreType], null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def genres
      object.genres.map do |genre_id|
        Genre.find(genre_id)
      end
    end
  end
end
