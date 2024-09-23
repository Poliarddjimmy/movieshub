module Mutations
  class UpdateReview < Mutations::BaseMutation
    argument :id, ID, required: true
    argument :content, String, required: true

    field :review, Types::ReviewType, null: true
    field :errors, [String], null: false

    def resolve(id:, content:)
      raise GraphQL::ExecutionError, "Not authorized" unless context[:current_user]

      review = Review.find(id)

      if review.user == context[:current_user]
        review.content = content

        if review.save
          { review: review, errors: [] }
        else
          { review: nil, errors: review.errors.full_messages }
        end
      else
        { review: nil, errors: ["Not authorized to update this review"] }
      end
    end
  end
end
