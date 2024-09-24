require 'rails_helper'

RSpec.describe 'Queries::FetchEpisode', type: :request do
  let(:user) { create(:user) }
  let!(:movie) { create(:movie) }
  let!(:season) { create(:season, movie: movie) }
  let!(:episode) { create(:episode, season: season, title: "Episode 1", episode_number: "1", duration: "30", video_url: "http://example.com/video1.mp4") }
  let(:token) { generate_token(user) }  # Use helper to generate token
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  let(:query) do
    <<~GQL
      query($id: ID!) {
        fetchEpisode(id: $id) {
          id
          episodeNumber
          title
          description
          duration
          videoUrl
        }
      }
    GQL
  end

  context 'when the episode exists' do
    it 'returns the episode details' do
      post '/graphql', params: { query: query, variables: { id: episode.id } }, headers: headers

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:success)
      expect(json['data']['fetchEpisode']).to include(
        'id' => episode.id.to_s,
        'episodeNumber' => episode.episode_number.to_s,
        'title' => episode.title,
        'description' => episode.description,
        'duration' => episode.duration.to_s,
        'videoUrl' => episode.video_url
      )
    end
  end

  context 'when the episode does not exist' do
    it 'returns null' do
      post '/graphql', params: { query: query, variables: { id: 'non-existent-id' } }

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:success)
      expect(json['data']['fetchEpisode']).to be_nil
    end
  end
end
