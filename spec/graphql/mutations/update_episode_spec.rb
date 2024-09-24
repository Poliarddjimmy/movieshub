require 'rails_helper'

RSpec.describe 'Mutations::UpdateEpisode', type: :request do
  let(:user) { create(:user) }
  let!(:movie) { create(:movie) }
  let!(:season) { create(:season, movie: movie) }
  let!(:episode) { create(:episode, season: season, episode_number: "1", title: "Episode 1", duration: "30", video_url: "http://example.com/video1.mp4") }
  let(:token) { generate_token(user) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  let(:mutation) do
    <<~GQL
      mutation UpdateEpisode($input: UpdateEpisodeInput!) {
        updateEpisode(input: $input) {
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
    it 'updates an episode successfully' do
      variables = {
        input: {
          id: episode.id,
          title: "Updated Episode 1",
          description: "This is an updated description.",
          duration: "35",
          videoUrl: "http://example.com/updated_video1.mp4"
        }
      }

      post '/graphql', params: { query: mutation, variables: variables }, headers: headers
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:success)
      expect(json['data']['updateEpisode']['episode']).to include(
        'id' => episode.id.to_s,
        'title' => "Updated Episode 1",
        'description' => "This is an updated description.",
        'duration' => "35",
        'videoUrl' => "http://example.com/updated_video1.mp4"
      )
      expect(json['data']['updateEpisode']['errors']).to be_empty
    end
  end

  context 'when the user is not authenticated' do
    it 'returns an error' do
      variables = {
        input: {
          id: episode.id,
          title: "Updated Episode 1",
          duration: "35",
          videoUrl: "http://example.com/updated_video1.mp4"
        }
      }

      post '/graphql', params: { query: mutation, variables: variables }
      json = JSON.parse(response.body)

      expect(json['errors'][0]['message']).to eq('You need to authenticate to perform this action')
    end
  end

  context 'when episode does not exist' do
    it 'returns an error' do
      variables = {
        input: {
          id: 'non-existent-id',  # Invalid ID
          title: "Updated Episode 1",
          duration: "35",
          videoUrl: "http://example.com/updated_video1.mp4"
        }
      }

      post '/graphql', params: { query: mutation, variables: variables }, headers: headers
      json = JSON.parse(response.body)

      expect(json['data']['updateEpisode']['episode']).to be_nil
      expect(json['data']['updateEpisode']['errors']).to include('Episode not found')
    end
  end
end
