require 'rails_helper'

RSpec.describe Queries::FetchMovies, type: :request do
  before(:each) do
    @user = create(:user)
    @movies = [create(:movie), create(:movie)]

    @token = AuthToken.token(@user, 0.00833333.hours.from_now.to_i)

    @query = <<~GQL
        query FetchMovies {
          fetchMovies {
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

  it "should fetch all movies successfully" do
    post '/graphql', params: { query: @query }, headers: { 'Authorization': "Bearer #{@token}" }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)

    @movies.each_with_index do |movie, index|
      expect(json['data']['fetchMovies'][index]).to include('title' => movie.title, 'plot' => movie.plot, 'synopsis' => movie.synopsis, 'actors' => movie.actors, 'releaseYear' => movie.release_year, 'director' => movie.director, 'language' => movie.language)
    end
  end

  it 'should raise error if the user is not authenticated' do
    post '/graphql', params: { query: @query }
    json = JSON.parse(response.body)
    expect(json['errors'][0]['message']).to eq('not authorized')
  end

end
