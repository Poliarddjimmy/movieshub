module Queries
  class FetchGenre < Queries::BaseQuery
    type Types::GenreType, null: false
    argument :id, ID, required: true

    def resolve(id:)
      raise GraphQL::ExecutionError, "Not authorized" unless context[:current_user]

      genre = Genre.find_by(id: id)
      raise GraphQL::ExecutionError, "Genre not found" unless genre

      genre
    end
  end
end
