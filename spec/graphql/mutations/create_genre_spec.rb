require 'rails_helper'

RSpec.describe 'Mutations::CreateGenre', type: :request do
  let(:user) { create(:user) }

  let(:mutation) do
    <<~GQL
      mutation CreateGenre($input: CreateGenreInput!) {
        createGenre(input: $input) {
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
        name: "Horror",
        description: "Scary and thrilling genre",
        imageUrl: "http://example.com/horror.jpg"
      }
    }
  end

  context "when the user is authenticated" do
    it 'creates a genre successfully' do
      token = generate_token(user)  # Use helper to generate token
      headers = { 'Authorization' => "Bearer #{token}" }

      post '/graphql', params: { query: mutation, variables: variables }, headers: headers
      json = JSON.parse(response.body)

      expect(json['data']['createGenre']['genre']).to include(
      'id' => '1',
        'name' => 'Horror',
        'description' => 'Scary and thrilling genre',
        'popularity' => 0,
        'isActive' => false,
        'imageUrl' => 'http://example.com/horror.jpg'
      )
      expect(json['data']['createGenre']['errors']).to be_empty
    end

    it 'returns errors if the name is missing' do
      variables[:input][:name] = nil
      token = generate_token(user)
      headers = { 'Authorization' => "Bearer #{token}" }

      post '/graphql', params: { query: mutation, variables: variables }, headers: headers
      json = JSON.parse(response.body)

      expect(json['errors'][0]['message']).to eq("Variable $input of type CreateGenreInput! was provided invalid value for name (Expected value to not be null)")
    end
  end

  context "when the user is not authenticated" do
    it "returns an authorization error" do
      post '/graphql', params: { query: mutation, variables: variables } # No token provided
      json = JSON.parse(response.body)

      expect(json['errors'][0]['message']).to eq("not authorized")
    end
  end
end
