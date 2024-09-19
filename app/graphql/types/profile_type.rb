# app/graphql/types/profile_type.rb
module Types
  class ProfileType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :user_id, Integer, null: false
    field :user, Types::UserType, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
