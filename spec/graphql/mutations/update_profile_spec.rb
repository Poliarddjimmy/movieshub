require 'rails_helper'

RSpec.describe Mutations::UpdateProfile, type: :request do
  let(:user) { create(:user) }
  let(:profile) { create(:profile, user: user) }
  let(:params) { { id: profile.id, name: 'New Name' } }

  let(:token) { AuthToken.token(user, 0.00833333.hours.from_now.to_i) }

  let(:mutation) do
    <<~GQL
      mutation UpdateProfile($input: UpdateProfileInput!) {
        updateProfile(input: $input) {
          profile {
            name
            userId
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

  it "should update a profile successfully" do
    post '/graphql', params: { query: mutation, variables: variables }, headers: { 'Authorization' => "Bearer #{token}" }

    json = JSON.parse(response.body)
    expect(json['data']['updateProfile']).to include(
      'profile' => { 'name' => 'New Name', 'userId' => user.id }
    )
  end

  it "should not update a profile with invalid name" do
    variables[:input][:name] = 'Ne'
    post '/graphql', params: { query: mutation, variables: variables }, headers: { 'Authorization' => "Bearer #{token}" }

    json = JSON.parse(response.body)
    expect(json['data']['updateProfile']['errors']).to include('The name must be at least 3 characters')
  end

  it "should raise error if the profile does not exist" do
    variables[:input][:id] = 0
    post '/graphql', params: { query: mutation, variables: variables }, headers: { 'Authorization' => "Bearer #{token}" }

    json = JSON.parse(response.body)
    expect(json['data']['updateProfile']['errors']).to include('Profile not found')
  end
end
