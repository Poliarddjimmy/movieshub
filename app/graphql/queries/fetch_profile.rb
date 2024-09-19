# app/graphql/queries/fetch_profile.rb
module Queries
  class FetchProfile < Queries::BaseQuery
    description "list a profile"

    type Types::ProfileType, null: true
    argument :id, ID, required: true

    def resolve(id:)
      raise GraphQL::ExecutionError, "not authorized" unless context[:current_user]

      profile = Profile.find_by(id: id)

      raise GraphQL::ExecutionError, "Could not find profile with id: #{id}" unless profile

      profile
    end
  end
end
