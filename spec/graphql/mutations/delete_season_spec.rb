require 'rails_helper'

RSpec.describe 'Mutations::DeleteSeason', type: :request do
  let(:user) { create(:user) }
  let(:movie) { create(:movie) }
  let(:season) { create(:season, movie: movie, season_number: 1, title: "Season 1") }
  let(:token) { generate_token(user) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  let(:mutation) do
    <<~GQL
      mutation DeleteSeason($input: DeleteSeasonInput!) {
        deleteSeason(input: $input) {
          message
          errors
        }
      }
    GQL
  end

  let(:variables) do
    {
      input: {
        id: season.id
      }
    }
  end

  context 'when the user is authenticated' do
    it 'deletes a season successfully' do
      post '/graphql', params: { query: mutation, variables: variables }, headers: headers
      json = JSON.parse(response.body)

      expect(json['data']['deleteSeason']['message']).to eq('Season deleted successfully')
      expect(json['data']['deleteSeason']['errors']).to be_empty
    end

    it 'returns an error when the season does not exist' do
      variables[:input][:id] = -1
      post '/graphql', params: { query: mutation, variables: variables }, headers: headers
      json = JSON.parse(response.body)

      expect(json['data']['deleteSeason']['message']).to eq('Failed to delete season')
      expect(json['data']['deleteSeason']['errors']).to include('Season not found')
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
