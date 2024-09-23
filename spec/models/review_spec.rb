require 'rails_helper'

RSpec.describe 'Mutations::CreateReview', type: :request do
  let(:user) { create(:user) }
  let(:movie) { create(:movie) }
  let(:token) { generate_token(user) }

  let(:mutation) do
    <<~GQL
      mutation CreateReview($input: CreateReviewInput!) {
        createReview(input: $input) {
          review {
            id
            content
          }
          errors
        }
      }
    GQL
  end

  context 'when the user is authenticated' do
    it 'creates a review successfully' do
      variables = {
        input: {
          content: "Great movie!",
          reviewableId: movie.id,
          reviewableType: "Movie",
          rating: "5"
        }
      }

      post '/graphql', params: { query: mutation, variables: variables }, headers: { 'Authorization' => "Bearer #{token}" }
      json = JSON.parse(response.body)

      expect(json['data']['createReview']['review']['content']).to eq("Great movie!")
      expect(json['data']['createReview']['errors']).to be_empty
    end
  end

  context 'when the user is not authenticated' do
    it 'returns an error' do
      variables = {
        input: {
          content: "Great movie!",
          reviewableId: movie.id,
          reviewableType: "Movie"
        }
      }

      post '/graphql', params: { query: mutation, variables: variables }
      json = JSON.parse(response.body)

      expect(json['errors'][0]['message']).to eq('Not authorized')
    end
  end
end
