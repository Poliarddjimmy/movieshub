require 'rails_helper'

RSpec.describe 'Mutations::DeleteMovieGenre', type: :request do
  let(:user) { create(:user) }
  let(:movie) { create(:movie) }
  let(:genre) { create(:genre) }
  let(:movie_genre) { create(:movie_genre, movie: movie, genre: genre) }
  let(:token) { generate_token(user) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  let(:mutation) do
    <<~GQL
      mutation DeleteMovieGenre($input: DeleteMovieGenreInput!) {
        deleteMovieGenre(input: $input) {
          message
          errors
        }
      }
    GQL
  end

  let(:variables) do
    {
      input: {
        id: movie_genre.id
      }
    }
  end

  context "when the user is authenticated" do
    it 'deletes a movie genre successfully' do
      post '/graphql', params: { query: mutation, variables: variables }, headers: headers
      json = JSON.parse(response.body)

      expect(json['data']['deleteMovieGenre']['message']).to eq('MovieGenre deleted successfully')
      expect(json['data']['deleteMovieGenre']['errors']).to be_empty
    end

    it 'returns an error when the movie genre is not found' do
      variables[:input][:id] = 0
      post '/graphql', params: { query: mutation, variables: variables }, headers: headers
      json = JSON.parse(response.body)

      expect(json['errors'][0]['message']).to eq('MovieGenre not found')
    end
  end

  context "when the user is not authenticated" do
    it 'returns an error' do
      post '/graphql', params: { query: mutation, variables: variables }
      json = JSON.parse(response.body)

      expect(json['errors'][0]['message']).to eq('You need to authenticate to perform this action')
    end
  end
end
