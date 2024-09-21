require 'rails_helper'

RSpec.describe Queries::FetchMovie, type: :request do
  let(:user) { create(:user) }
  let(:movie) { create(:movie) }

  let(:token) { AuthToken.token(user, 0.00833333.hours.from_now.to_i) }

  let(:query) do
    <<~GQL
      query FetchMovie($id: ID!) {
        fetchMovie(id: $id) {
          title
          plot
          synopsis
          actors
          releaseYear
          director
          language
        }
      }
    GQL
  end

  let(:variables) do
    {
      id: movie.id
    }
  end

  it "should fetch a movie successfully" do
    post '/graphql', params: { query: query, variables: variables }, headers: { 'Authorization': "Bearer #{token}" }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json['data']['fetchMovie']).to include('title' => movie.title, 'plot' => movie.plot, 'synopsis' => movie.synopsis, 'actors' => movie.actors, 'releaseYear' => movie.release_year, 'director' => movie.director, 'language' => movie.language)
  end

  it 'should raise error if the movie does not exist' do
    variables[:id] = 0
    post '/graphql', params: { query: query, variables: variables }, headers: { 'Authorization': "Bearer #{token}" }
    json = JSON.parse(response.body)
    expect(json['errors'][0]['message']).to eq('movie not found')
  end

  it 'should raise error if the user is not authenticated' do
    post '/graphql', params: { query: query, variables: variables }
    json = JSON.parse(response.body)
    expect(json['errors'][0]['message']).to eq('not authorized')
  end

end
