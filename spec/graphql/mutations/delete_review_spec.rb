require 'rails_helper'

RSpec.describe 'Mutations::DeleteReview', type: :request do
  let(:user) { create(:user, email: 'user@example.com') }
  let(:movie) { create(:movie) }
  let(:review) { create(:review, user: user, reviewable: movie) }
  let(:token) { generate_token(user) }

  let(:mutation) do
    <<~GQL
      mutation DeleteReview($input: DeleteReviewInput!) {
        deleteReview(input: $input) {
          message
          errors
        }
      }
    GQL
  end

  context 'when the user is authenticated' do
    it 'deletes the review successfully' do
      variables = {
        input: {
          id: review.id
        }
      }

      post '/graphql', params: { query: mutation, variables: variables }, headers: { 'Authorization' => "Bearer #{token}" }
      json = JSON.parse(response.body)

      expect(json['data']['deleteReview']['message']).to eq("Review deleted successfully")
      expect(json['data']['deleteReview']['errors']).to be_empty
      expect { review.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'returns errors if the review does not belong to the user' do
      another_user = create(:user)
      another_review = create(:review, user: another_user, reviewable: movie)

      variables = {
        input: {
          id: another_review.id
        }
      }

      post '/graphql', params: { query: mutation, variables: variables }, headers: { 'Authorization' => "Bearer #{token}" }
      json = JSON.parse(response.body)

      expect(json['data']['deleteReview']['message']).to be_nil
      expect(json['data']['deleteReview']['errors']).to include("Not authorized to delete this review")
    end
  end

  context 'when the user is not authenticated' do
    it 'returns an error' do
      variables = {
        input: {
          id: review.id
        }
      }

      post '/graphql', params: { query: mutation, variables: variables }
      json = JSON.parse(response.body)

      expect(json['errors'][0]['message']).to eq('Not authorized')
    end
  end
end
