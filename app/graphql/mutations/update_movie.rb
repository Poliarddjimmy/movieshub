# app/graphql/mutations/update_movie.rb
module Mutations
  class UpdateMovie < Mutations::BaseMutation
    argument :id, ID, required: true
    argument :title, String, required: false
    argument :plot, String, required: false
    argument :synopsis, String, required: false
    argument :actors, [String], required: false
    argument :release_year, Integer, required: false
    argument :director, String, required: false
    argument :language, String, required: false
    argument :duration, Integer, required: false
    argument :rating, Integer, required: false
    argument :poster_url, String, required: false
    argument :slug, String, required: false
    argument :genres, [Integer], required: false

    field :movie, Types::MovieType, null: true
    field :errors, [String], null: false

    def resolve(id:, **attributes)
      raise GraphQL::ExecutionError, "not authorized" unless context[:current_user]

      movie = Movie.find(id)
      if movie.update(attributes)
        { movie: movie, errors: [] }
      else
        { movie: nil, errors: movie.errors.full_messages }
      end
    end
  end
end
