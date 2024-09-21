require 'rails_helper'

RSpec.describe Queries::FetchGenre, type: :request do
  let(:user) { create(:user) }
  let(:genre) { create(:genre) }
  let(:token) { generate_token(user) }  # Use helper to generate token
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  let(:token) { AuthToken.token(user, 0.00833333.hours.from_now.to_i) }

  let(:query) do
    <<~GQL
      query FetchGenre($id: ID!) {
        fetchGenre(id: $id) {
          id
          name
          description
          popularity
          isActive
          imageUrl
        }
      }
    GQL
  end

  let(:variables) do
    {
      id: genre.id
    }
  end

  it "should fetch a genre successfully" do
    post '/graphql', params: { query: query, variables: variables }, headers: headers
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)

    expect(json['data']['fetchGenre']).to include('id' => genre.id.to_s, 'name' => genre.name, 'description' => genre.description, 'popularity' => genre.popularity, 'isActive' => genre.is_active, 'imageUrl' => genre.image_url)
  end

  it 'should return an error if genre is not found' do
    post '/graphql', params: { query: query, variables: { id: 0 } }, headers: headers
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json['errors'][0]['message']).to eq("Genre not found")
  end

  it "should return an error if user is not authenticated" do
    post '/graphql', params: { query: query, variables: variables }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json['errors'][0]['message']).to eq("Not authorized")
  end
end
