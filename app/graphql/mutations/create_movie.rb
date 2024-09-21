# app/graphql/mutations/create_movie.rb
module Mutations
  class CreateMovie < Mutations::BaseMutation
    argument :title, String, required: true
    argument :plot, String, required: false
    argument :synopsis, String, required: false
    argument :actors, [String], required: false
    argument :release_year, Integer, required: false
    argument :director, String, required: false
    argument :language, String, required: false
    argument :duration, Integer, required: false
    argument :rating, Integer, required: false
    argument :poster_url, String, required: false
    argument :slug, String, required: true
    argument :genres, [Integer], required: false

    field :movie, Types::MovieType, null: true
    field :errors, [String], null: false

    def resolve(args)
      raise GraphQL::ExecutionError, "not authorized" unless context[:current_user]

      begin
        movie = Movie.new(args)
        if movie.save
          { movie: movie, errors: [] }
        else
          { movie: nil, errors: movie.errors.full_messages }
        end
      rescue ActiveRecord::RecordInvalid => e
        { movie: nil, errors: [e.message] }
      end
    end
  end
end
