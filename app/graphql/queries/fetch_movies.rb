# app/graphql/queries/fetch_movies.rb
module Queries
  class FetchMovies < Queries::BaseQuery
    type [Types::MovieType], null: false

    def resolve
      raise GraphQL::ExecutionError, "not authorized" unless context[:current_user]

      Movie.all
    end
  end
end
