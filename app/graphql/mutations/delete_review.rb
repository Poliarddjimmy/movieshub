module Mutations
  class DeleteReview < Mutations::BaseMutation
    argument :id, ID, required: true

    field :message, String, null: true
    field :errors, [String], null: false

    def resolve(id:)
      raise GraphQL::ExecutionError, "Not authorized" unless context[:current_user]

      review = Review.find(id)

      if review.user == context[:current_user]
        review.destroy
        { message: "Review deleted successfully", errors: [] }
      else
        { message: nil, errors: ["Not authorized to delete this review"] }
      end
    end
  end
end
