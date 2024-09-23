require 'rails_helper'

RSpec.describe 'Mutations::CreateWatching', type: :request do
  let(:user) { create(:user, email: 'test@example.com') }
  let(:movie) { create(:movie) }
  let(:profile) { create(:profile) }
  let(:token) { generate_token(user) }

  let(:mutation) do
    <<~GQL
      mutation CreateWatching($input: CreateWatchingInput!) {
        createWatching(input: $input) {
          watching {
            id
            status
            progress
            startedAt
            finishedAt
          }
          errors
        }
      }
    GQL
  end

  context 'when the user is authenticated' do
    it 'creates a watching successfully' do
      variables = {
        input: {
          movieId: movie.id,
          profileId: profile.id,
          status: "watching",
          progress: "0",
          startedAt: Time.now.iso8601
        }
      }

      post '/graphql', params: { query: mutation, variables: variables }, headers: { 'Authorization' => "Bearer #{token}" }
      json = JSON.parse(response.body)

      expect(json['data']['createWatching']['watching']['status']).to eq("watching")
      expect(json['data']['createWatching']['errors']).to be_empty
    end
  end

  context 'when the user is not authenticated' do
    it 'returns an error' do
      variables = {
        input: {
          movieId: movie.id,
          profileId: profile.id,
          status: "watching",
          progress: 0
        }
      }

      post '/graphql', params: { query: mutation, variables: variables }
      json = JSON.parse(response.body)

      expect(json['errors'][0]['message']).to eq('You need to authenticate to perform this action')
    end
  end
end
