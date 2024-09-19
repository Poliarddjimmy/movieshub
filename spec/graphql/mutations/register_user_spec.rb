# spec/graphql/mutations/register_user_spec.rb
require 'rails_helper'

RSpec.describe Mutations::RegisterUser, type: :request do
  let(:mutation) do
    <<~GQL
      mutation RegisterUser($input: RegisterUserInput!) {
        registerUser(input: $input) {
          user {
            firstName
            lastName
          }
          token
          errors
        }
      }
    GQL
  end

  let(:variables) do
    {
      input: {
        email: 'test@example.com',
        password: 'password123',
        firstName: 'Test',
        lastName: 'User'
      }
    }
  end

  it 'registers a user successfully' do
    post '/graphql', params: { query: mutation, variables: variables }

    json = JSON.parse(response.body)
    expect(json['data']['registerUser']).to include(
      'user' => a_hash_including('firstName' => 'Test', 'lastName' => 'User')
    )
  end

  it 'should not register a user with invalid email' do
    variables[:input][:email] = 'testexample.com'
    post '/graphql', params: { query: mutation, variables: variables }

    json = JSON.parse(response.body)
    expect(json['data']['registerUser']).to include(
      'errors' => ['Email is invalid']
    )
  end

  it 'should not register a user with invalid password' do
    variables[:input][:password] = 'passw'
    post '/graphql', params: { query: mutation, variables: variables }

    json = JSON.parse(response.body)
    expect(json['data']['registerUser']).to include(
      'errors' => ["Password is too short (minimum is 6 characters)", "The Password must be at least 6 characters"]
    )
  end
end
