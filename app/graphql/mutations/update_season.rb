module Mutations
  class UpdateSeason < BaseMutation
    argument :id, ID, required: true
    argument :season_number, String, required: false
    argument :title, String, required: false
    argument :description, String, required: false

    field :season, Types::SeasonType, null: true
    field :errors, [String], null: false

    def resolve(id:, season_number: nil, title: nil, description: nil)
      raise GraphQL::ExecutionError, "You need to authenticate to perform this action" unless context[:current_user]

      season = Season.find_by(id: id)

      return { season: nil, errors: ['Season not found'] } unless season

      season.season_number = season_number if season_number
      season.title = title if title
      season.description = description if description

      if season.save
        { season: season, errors: [] }
      else
        { season: nil, errors: season.errors.full_messages }
      end
    end
  end
end
