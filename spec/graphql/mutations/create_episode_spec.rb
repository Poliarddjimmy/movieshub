require 'rails_helper'

RSpec.describe 'Mutations::CreateEpisode', type: :request do
  let(:user) { create(:user) }
  let!(:movie) { create(:movie) }
  let!(:season) { create(:season, movie: movie) }
  let(:token) { generate_token(user) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  let(:mutation) do
    <<~GQL
      mutation CreateEpisode($input: CreateEpisodeInput!) {
        createEpisode(input: $input) {
          episode {
            id
            episodeNumber
            title
            description
            duration
            videoUrl
          }
          errors
        }
      }
    GQL
  end

  context 'when the user is authenticated' do
    it 'creates an episode successfully' do
      variables = {
        input: {
          seasonId: season.id,
          episodeNumber: "1",
          title: "Episode 1",
          description: "This is the first episode.",
          duration: "30",
          videoUrl: "http://example.com/video1.mp4"
        }
      }

      post '/graphql', params: { query: mutation, variables: variables }, headers: headers
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:success)
      expect(json['data']['createEpisode']['episode']).to include(
        'episodeNumber' => "1",
        'title' => "Episode 1",
        'description' => "This is the first episode.",
        'duration' => "30",
        'videoUrl' => "http://example.com/video1.mp4"
      )
      expect(json['data']['createEpisode']['errors']).to be_empty
    end
  end

  context 'when the user is not authenticated' do
    it 'returns an error' do
      variables = {
        input: {
          seasonId: season.id,
          episodeNumber: "1",
          title: "Episode 1",
          duration: "30",
          videoUrl: "http://example.com/video1.mp4"
        }
      }

      post '/graphql', params: { query: mutation, variables: variables }
      json = JSON.parse(response.body)

      expect(json['errors'][0]['message']).to eq('You need to authenticate to perform this action')
    end
  end

end
