require 'rails_helper'

RSpec.describe 'Mutations::CreateSeason', type: :request do
  let(:user) { create(:user) }
  let(:movie) { create(:movie) }
  let(:token) { generate_token(user) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  let(:mutation) do
    <<~GQL
      mutation CreateSeason($input: CreateSeasonInput!) {
        createSeason(input: $input) {
          season {
            id
            seasonNumber
            title
            description
          }
          errors
        }
      }
    GQL
  end

  let(:variables) do
    {
      input: {
        movieId: movie.id,
        seasonNumber: "1",
        title: "Season 1",
        description: "This is the first season"
      }
    }
  end

  context 'when the user is authenticated' do
    it 'creates a season successfully' do
      post '/graphql', params: { query: mutation, variables: variables }, headers: headers
      json = JSON.parse(response.body)

      expect(json['data']['createSeason']['season']['title']).to eq('Season 1')
      expect(json['data']['createSeason']['errors']).to be_empty
    end
  end

  context 'when the user is not authenticated' do
    it 'returns an error' do
      post '/graphql', params: { query: mutation, variables: variables }
      json = JSON.parse(response.body)

      expect(json['errors'][0]['message']).to eq('You need to authenticate to perform this action')
    end
  end
end
