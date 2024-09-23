require 'rails_helper'

RSpec.describe 'Mutations::UpdateWatching', type: :request do
  let(:user) { create(:user, email: 'test@example.com') }
  let(:movie) { create(:movie) }
  let(:profile) { create(:profile, user: user) } # Ensure profile is associated with the user
  let(:watching) { create(:watching, user: user, movie: movie, profile: profile, status: "watching", progress: 50) }
  let(:token) { generate_token(user) }

  let(:mutation) do
    <<~GQL
      mutation UpdateWatching($input: UpdateWatchingInput!) {
        updateWatching(input: $input) {
          watching {
            id
            status
            progress
            finishedAt
          }
          errors
        }
      }
    GQL
  end

  context 'when the user is authenticated' do
    it 'updates the watching successfully' do
      variables = {
        input: {
          id: watching.id,
          status: "completed",
          progress: "100",
          finishedAt: Time.now.iso8601
        }
      }

      post '/graphql', params: { query: mutation, variables: variables }, headers: { 'Authorization' => "Bearer #{token}" }
      json = JSON.parse(response.body)

      expect(json['data']['updateWatching']['watching']['status']).to eq("completed")
      expect(json['data']['updateWatching']['watching']['progress']).to eq("100")
      expect(json['data']['updateWatching']['watching']['finishedAt']).not_to be_nil
      expect(json['data']['updateWatching']['errors']).to be_empty
    end

    it 'returns errors if the watching record does not exist' do
      variables = {
        input: {
          id: 9999,  # Assuming this ID does not exist
          status: "completed"
        }
      }

      post '/graphql', params: { query: mutation, variables: variables }, headers: { 'Authorization' => "Bearer #{token}" }
      json = JSON.parse(response.body)

      expect(json['data']['updateWatching']['watching']).to be_nil
      expect(json['data']['updateWatching']['errors']).to include("Watching not found")
    end

    it 'returns errors if the watching does not belong to the user' do
      another_user = create(:user)
      another_watching = create(:watching, user: another_user, movie: movie, profile: profile)

      variables = {
        input: {
          id: another_watching.id,
          status: "completed"
        }
      }

      post '/graphql', params: { query: mutation, variables: variables }, headers: { 'Authorization' => "Bearer #{token}" }
      json = JSON.parse(response.body)

      expect(json['data']['updateWatching']['watching']).to be_nil
      expect(json['data']['updateWatching']['errors']).to include("Watching not found")
    end
  end

  context 'when the user is not authenticated' do
    it 'returns an error' do
      variables = {
        input: {
          id: watching.id,
          status: "completed"
        }
      }

      post '/graphql', params: { query: mutation, variables: variables }
      json = JSON.parse(response.body)

      expect(json['errors'][0]['message']).to eq('You need to authenticate to perform this action')
    end
  end
end
