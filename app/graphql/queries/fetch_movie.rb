# app/graphql/queries/fetch_movie.rb
module Queries
  class FetchMovie < Queries::BaseQuery
    type Types::MovieType, null: true
    argument :id, ID, required: true

    def resolve(id:)
      raise GraphQL::ExecutionError, "not authorized" unless context[:current_user]
      raise GraphQL::ExecutionError, "movie not found" unless Movie.exists?(id: id)

      Movie.find_by(id: id)
    end
  end
end
