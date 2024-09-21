require 'rails_helper'

RSpec.describe 'Mutations::UpdateGenre', type: :request do
  let(:user) { create(:user) }
  let(:genre) { create(:genre) }
  let(:params) { { id: genre.id, name: 'New Name' } }
  let(:token) { generate_token(user) }  # Use helper to generate token
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  let(:mutation) do
    <<~GQL
      mutation UpdateGenre($input: UpdateGenreInput!) {
        updateGenre(input: $input) {
          genre {
            id
            name
            description
            popularity
            isActive
            imageUrl
          }
          errors
        }
      }
    GQL
  end

  let(:variables) do
    {
      input: {
        id: params[:id],
        name: params[:name]
      }
    }
  end

  it "should update a genre successfully" do
    post '/graphql', params: { query: mutation, variables: variables }, headers: headers
    expect(response).to have_http_status(:ok)

    json = JSON.parse(response.body)

    expect(json['data']['updateGenre']['genre']).to include(
      'id' => genre.id.to_s,
      'name' => 'New Name',
      'description' => genre.description,
      'popularity' => genre.popularity,
      'isActive' => genre.is_active,
      'imageUrl' => genre.image_url
    )
  end

  it "should return errors if the user is not authenticated" do
    post '/graphql', params: { query: mutation, variables: variables }
    expect(response).to have_http_status(:ok)

    json = JSON.parse(response.body)
    expect(json['errors'][0]['message']).to eq("not authorized")
  end
end
