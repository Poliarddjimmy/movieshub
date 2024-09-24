require 'rails_helper'

RSpec.describe 'Mutations::UpdateSeason', type: :request do
  let(:user) { create(:user) }
  let(:movie) { create(:movie) }
  let(:season) { create(:season, movie: movie, season_number: 1, title: "Season 1") }
  let(:token) { generate_token(user) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  let(:mutation) do
    <<~GQL
      mutation UpdateSeason($input: UpdateSeasonInput!) {
        updateSeason(input: $input) {
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
        id: season.id,
        title: "Updated Season Title"
      }
    }
  end

  context 'when the user is authenticated' do
    it 'updates a season successfully' do
      post '/graphql', params: { query: mutation, variables: variables }, headers: headers
      json = JSON.parse(response.body)

      expect(json['data']['updateSeason']['season']['title']).to eq('Updated Season Title')
      expect(json['data']['updateSeason']['errors']).to be_empty
    end

    it 'returns an error when the season does not exist' do
      variables[:input][:id] = -1
      post '/graphql', params: { query: mutation, variables: variables }, headers: headers
      json = JSON.parse(response.body)

      expect(json['data']['updateSeason']['season']).to be_nil
      expect(json['data']['updateSeason']['errors']).to include('Season not found')
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
