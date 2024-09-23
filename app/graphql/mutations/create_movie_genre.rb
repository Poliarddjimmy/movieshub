module Mutations
  class CreateMovieGenre < Mutations::BaseMutation
    argument :movie_id, ID, required: true
    argument :genre_id, ID, required: true

    field :movie_genre, Types::MovieGenreType, null: true
    field :errors, [String], null: false

    def resolve(movie_id:, genre_id:)
      raise GraphQL::ExecutionError, "You need to authenticate to perform this action" unless context[:current_user]

      movie_genre = MovieGenre.new(movie_id: movie_id, genre_id: genre_id)

      if movie_genre.save
        { movie_genre: movie_genre, errors: [] }
      else
        { movie_genre: nil, errors: movie_genre.errors.full_messages }
      end
    end
  end
end
