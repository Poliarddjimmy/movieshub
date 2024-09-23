require 'rails_helper'

RSpec.describe 'Mutations::UpdateReview', type: :request do
  let(:user) { create(:user, email: 'user@example.com') }
  let(:movie) { create(:movie) }
  let(:review) { create(:review, user: user, reviewable: movie) }
  let(:token) { generate_token(user) }

  let(:mutation) do
    <<~GQL
      mutation UpdateReview($input: UpdateReviewInput!) {
        updateReview(input: $input) {
          review {
            content
          }
          errors
        }
      }
    GQL
  end

  context 'when the user is authenticated' do
    it 'updates the review successfully' do
      variables = {
        input: {
          id: review.id,
          content: "Updated review content"
        }
      }

      post '/graphql', params: { query: mutation, variables: variables }, headers: { 'Authorization' => "Bearer #{token}" }
      json = JSON.parse(response.body)

      expect(json['data']['updateReview']['review']['content']).to eq("Updated review content")
      expect(json['data']['updateReview']['errors']).to be_empty
    end

    it 'returns errors if the review does not belong to the user' do
      another_user = create(:user)
      another_review = create(:review, user: another_user, reviewable: movie)

      variables = {
        input: {
          id: another_review.id,
          content: "Unauthorized update attempt"
        }
      }

      post '/graphql', params: { query: mutation, variables: variables }, headers: { 'Authorization' => "Bearer #{token}" }
      json = JSON.parse(response.body)

      expect(json['data']['updateReview']['review']).to be_nil
      expect(json['data']['updateReview']['errors']).to include("Not authorized to update this review")
    end
  end

  context 'when the user is not authenticated' do
    it 'returns an error' do
      variables = {
        input: {
          id: review.id,
          content: "Attempted update"
        }
      }

      post '/graphql', params: { query: mutation, variables: variables }
      json = JSON.parse(response.body)

      expect(json['errors'][0]['message']).to eq('Not authorized')
    end
  end
end
