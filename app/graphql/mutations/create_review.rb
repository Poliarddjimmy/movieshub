module Mutations
  class CreateReview < Mutations::BaseMutation
    argument :content, String, required: true
    argument :reviewable_id, ID, required: true
    argument :reviewable_type, String, required: true
    argument :rating, String, required: false

    field :review, Types::ReviewType, null: true
    field :errors, [String], null: false

    def resolve(content:, reviewable_id:, reviewable_type:, rating: 1)
      raise GraphQL::ExecutionError, "Not authorized" unless context[:current_user]

      begin
        review = Review.create!(content: content, reviewable_id: reviewable_id, reviewable_type: reviewable_type, user: context[:current_user], rating: rating)

        {review: review, errors: []}
      rescue ActiveRecord::RecordInvalid => e
        {review: nil, errors: e.record.errors.full_messages}
      end



    end
  end
end
