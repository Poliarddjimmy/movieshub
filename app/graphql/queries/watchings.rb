# app/graphql/queries/watchings.rb
module Queries
  class Watchings < Queries::BaseQuery
    type [Types::WatchingType], null: false

    def resolve
      user = context[:current_user]
      raise GraphQL::ExecutionError, "You need to authenticate to perform this action" unless user

      user.watchings
    end
  end
end
