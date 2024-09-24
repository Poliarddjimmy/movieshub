module Types
  class SeasonType < Types::BaseObject
    field :id, ID, null: false
    field :movie_id, ID, null: false
    field :season_number, String, null: false
    field :title, String, null: false
    field :description, String, null: true
    field :episodes, [Types::EpisodeType], null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
