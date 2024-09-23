require 'rails_helper'

RSpec.describe 'Mutations::CreateMovieGenre', type: :request do
  let(:user) { create(:user) }
  let(:movie) { create(:movie) }
  let(:genre) { create(:genre) }
  let(:token) { generate_token(user) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  let(:mutation) do
    <<~GQL
      mutation CreateMovieGenre($input: CreateMovieGenreInput!) {
        createMovieGenre(input: $input) {
          movieGenre {
            id
            genre {
              id
              name
            }
            movie {
              id
              title
            }
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
        genreId: genre.id
      }
    }
  end

  context "when the user is authenticated" do
    it 'creates a movie genre successfully' do
      post '/graphql', params: { query: mutation, variables: variables }, headers: headers
      json = JSON.parse(response.body)

      expect(json['data']['createMovieGenre']['movieGenre']).to include(
        'id' => '1',
        'genre' => {
          'id' => genre.id.to_s,
          'name' => genre.name
        },
        'movie' => {
          'id' => movie.id.to_s,
          'title' => movie.title
        }
      )
      expect(json['data']['createMovieGenre']['errors']).to be_empty
    end
  end

  context "when the user is not authenticated" do
    it 'returns an authentication error' do
      post '/graphql', params: { query: mutation, variables: variables }
      json = JSON.parse(response.body)

      expect(json['errors'].first['message']).to eq("You need to authenticate to perform this action")
    end
  end
end
