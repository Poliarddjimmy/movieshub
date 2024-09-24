module Mutations
  class CreateSeason < BaseMutation
    argument :movie_id, ID, required: true
    argument :season_number, String, required: true
    argument :title, String, required: true
    argument :description, String, required: false

    field :season, Types::SeasonType, null: true
    field :errors, [String], null: false

    def resolve(movie_id:, season_number:, title:, description: nil)
      raise GraphQL::ExecutionError, "You need to authenticate to perform this action" unless context[:current_user]

      season = Season.new(
        movie_id: movie_id,
        season_number: season_number,
        title: title,
        description: description
      )

      if season.save
        { season: season, errors: [] }
      else
        { season: nil, errors: season.errors.full_messages }
      end
    end
  end
end
