module Queries
  class FetchGenres < Queries::BaseQuery
    type [Types::GenreType], null: false

    def resolve
      raise GraphQL::ExecutionError, "Not authorized" unless context[:current_user]
      Genre.all
    end
  end
end
