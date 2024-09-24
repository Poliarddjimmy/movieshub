module Mutations
  class DeleteSeason < BaseMutation
    argument :id, ID, required: true

    field :message, String, null: true
    field :errors, [String], null: false

    def resolve(id:)
      raise GraphQL::ExecutionError, "You need to authenticate to perform this action" unless context[:current_user]

      season = Season.find_by(id: id)

      return { message: "Failed to delete season", errors: ['Season not found'] } unless season

      if season&.destroy
        { message: "Season deleted successfully", errors: [] }
      else
        { message: "Failed to delete season", errors: ["Season not found"] }
      end
    end
  end
end
