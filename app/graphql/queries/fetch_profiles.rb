# app/graphql/queries/fetch_profile.rb
module Queries
  class FetchProfiles < Queries::BaseQuery
    description "list all profiles"

    type [Types::ProfileType], null: false

    def resolve
      raise GraphQL::ExecutionError, "not authorized" unless context[:current_user]

      user = context[:current_user]
      user.profiles
    end
  end
end
