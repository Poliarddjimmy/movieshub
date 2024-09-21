require 'rails_helper'

RSpec.describe Queries::FetchGenres, type: :request do
  before(:each) do
    @user = create(:user)
    @genres = [create(:genre), create(:genre, :name => 'Action', :description => 'Action movies', :popularity => 5, :is_active => true, :image_url => 'https://www.action.com')]

    @token = AuthToken.token(@user, 0.00833333.hours.from_now.to_i)

    @query = <<~GQL
        query FetchGenres {
          fetchGenres {
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

  it "should fetch all genres successfully" do
    post '/graphql', params: { query: @query }, headers: { 'Authorization': "Bearer #{@token}" }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)

    @genres.each_with_index do |genre, index|
      expect(json['data']['fetchGenres'][index]).to include('id' => genre.id.to_s, 'name' => genre.name, 'description' => genre.description, 'popularity' => genre.popularity, 'isActive' => genre.is_active, 'imageUrl' => genre.image_url)
    end
  end

  it 'should raise error if the user is not authenticated' do
    post '/graphql', params: { query: @query }
    json = JSON.parse(response.body)
    expect(json['errors'][0]['message']).to eq('Not authorized')
  end

end
