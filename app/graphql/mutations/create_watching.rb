# app/graphql/mutations/create_watching.rb
module Mutations
  class CreateWatching < BaseMutation
    argument :movie_id, ID, required: true
    argument :profile_id, ID, required: true
    argument :status, String, required: true
    argument :progress, String, required: true
    argument :started_at, GraphQL::Types::ISO8601DateTime, required: false
    argument :finished_at, GraphQL::Types::ISO8601DateTime, required: false

    field :watching, Types::WatchingType, null: true
    field :errors, [String], null: false

    def resolve(movie_id:, profile_id:, status:, progress:, started_at: nil, finished_at: nil)
      user = context[:current_user]
      raise GraphQL::ExecutionError, "You need to authenticate to perform this action" unless user

      watching = Watching.new(
        user: user,
        movie_id: movie_id,
        profile_id: profile_id,
        status: status,
        progress: progress,
        started_at: started_at,
        finished_at: finished_at
      )

      if watching.save
        { watching: watching, errors: [] }
      else
        { watching: nil, errors: watching.errors.full_messages }
      end
    end
  end
end
