# app/graphql/mutations/update_watching.rb
module Mutations
  class UpdateWatching < BaseMutation
    argument :id, ID, required: true
    argument :status, String, required: false
    argument :progress, String, required: false
    argument :finished_at, GraphQL::Types::ISO8601DateTime, required: false

    field :watching, Types::WatchingType, null: true
    field :errors, [String], null: false

    def resolve(id:, status: nil, progress: nil, finished_at: nil)
      user = context[:current_user]
      raise GraphQL::ExecutionError, "You need to authenticate to perform this action" unless user

      watching = Watching.find_by(id: id, user: user)

      return { watching: nil, errors: ['Watching not found'] } unless watching

      watching.status = status if status
      watching.progress = progress if progress
      watching.finished_at = finished_at if finished_at

      if watching.save
        { watching: watching, errors: [] }
      else
        { watching: nil, errors: watching.errors.full_messages }
      end
    end
  end
end
