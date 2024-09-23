module Types
  class ReviewType < Types::BaseObject
    field :id, ID, null: false
    field :content, String, null: false
    field :user, Types::UserType, null: false # Assuming you have a UserType
    field :reviewable_id, ID, null: false
    field :reviewable_type, String, null: false
    field :rating, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
