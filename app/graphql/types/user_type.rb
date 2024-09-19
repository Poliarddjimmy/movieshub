# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :first_name, String, null: true
    field :last_name, String, null: true
    field :full_name, String, null: true
    field :slug, String, null: true
    field :email, String, null: true
    field :password_digest, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
