require 'rails_helper'

RSpec.describe Mutations::CreateProfile, type: :request do
  let (:user) { create(:user) }
  let (:params) { { name: 'Test Profile', user_id: user.id } }
  let(:token) { AuthToken.token(user, 0.00833333.hours.from_now.to_i) }

  let(:mutation) do
    <<~GQL
      mutation CreateProfile($input: CreateProfileInput!) {
        createProfile(input: $input) {
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
        name: params[:name],
        userId: params[:user_id]
      }
    }
  end

  it 'creates a profile successfully' do
    post '/graphql', params: { query: mutation, variables: variables }, headers: { 'Authorization': "Bearer #{token}" }

    json = JSON.parse(response.body)
    expect(json['data']['createProfile']).to include(
      'profile' => a_hash_including('name' => params[:name], 'userId' => user.id)
    )
  end

  it 'should not create a profile with invalid name' do
    variables[:input][:name] = 'Te'
    post '/graphql', params: { query: mutation, variables: variables }, headers: { 'Authorization': "Bearer #{token}" }

    json = JSON.parse(response.body)
    expect(json['data']['createProfile']['errors']).to include('The name must be at least 3 characters')
  end

  it 'should raise error if the user does not exist' do
    variables[:input][:userId] = 0
    post '/graphql', params: { query: mutation, variables: variables }, headers: { 'Authorization': "Bearer #{token}" }

    json = JSON.parse(response.body)
    expect(json['data']['createProfile']['errors']).to include('User not found')
  end

  it 'should not create a profile it he user already has teb profile' do
    create(:profile, user: user)
    10.times { user.profiles.create(name: 'Profile') }
    post '/graphql', params: { query: mutation, variables: variables }, headers: { 'Authorization': "Bearer #{token}" }

    json = JSON.parse(response.body)
    expect(json['data']['createProfile']).to include(
      'errors' => ['The user already has ten profiles']
    )
  end
end
