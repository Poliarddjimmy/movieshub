# app/graphql/types/watching_type.rb
module Types
  class WatchingType < Types::BaseObject
    field :id, ID, null: false
    field :user, Types::UserType, null: false
    field :movie, Types::MovieType, null: false
    field :profile, Types::ProfileType, null: false
    field :status, String, null: false
    field :progress, String, null: false
    field :started_at, GraphQL::Types::ISO8601DateTime, null: true
    field :finished_at, GraphQL::Types::ISO8601DateTime, null: true
  end
end
