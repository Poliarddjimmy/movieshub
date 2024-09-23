module Types
  class GenreType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :description, String, null: true
    field :slug, String, null: false
    field :popularity, Integer, null: true
    field :is_active, Boolean, null: false
    field :image_url, String, null: true
    field :movie_genres, [Types::MovieGenreType], null: true
    field :movies, [Types::MovieType], null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
