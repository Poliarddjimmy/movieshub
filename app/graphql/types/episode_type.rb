module Types
  class EpisodeType < Types::BaseObject
    field :id, ID, null: false
    field :episode_number, String, null: false
    field :title, String, null: false
    field :description, String, null: true
    field :duration, String, null: false
    field :video_url, String, null: false
    field :season, Types::SeasonType, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
