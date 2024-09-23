module Mutations
  class DeleteMovieGenre < Mutations::BaseMutation
    argument :id, ID, required: true

    field :message, String, null: true
    field :errors, [String], null: false

    def resolve(id:)
      raise GraphQL::ExecutionError, "You need to authenticate to perform this action" unless context[:current_user]

      movie_genre = MovieGenre.find_by(id: id)
      raise GraphQL::ExecutionError, "MovieGenre not found" unless movie_genre

      if movie_genre
        movie_genre.destroy
        { message: "MovieGenre deleted successfully", errors: [] }
      else
        { message: nil, errors: ["MovieGenre not found"] }
      end
    end
  end
end
