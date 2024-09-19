require 'rails_helper'

RSpec.describe Mutations::LoginUser, type: :request do
  let (:user) { create(:user) }
  let (:params) { { email: user.email, password: user.password } }
  let(:mutation) do
    <<~GQL
      mutation LoginUser($input: LoginUserInput!) {
        loginUser(input: $input) {
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
        email: params[:email],
        password: params[:password]
      }
    }
  end

  it 'logs in a user successfully' do
    post '/graphql', params: { query: mutation, variables: variables }

    json = JSON.parse(response.body)
    expect(json['data']['loginUser']).to include(
      'user' => a_hash_including('firstName' => user.first_name, 'lastName' => user.last_name)
    )
  end

  it 'should not log in a user with invalid email' do
    variables[:input][:email] = 'testexample.com'
    post '/graphql', params: { query: mutation, variables: variables }

    json = JSON.parse(response.body)
    expect(json['data']['loginUser']).to include(
      'errors' => ['Invalid email or password']
    )
  end

  it 'should not log in a user with invalid password' do
    variables[:input][:password] = 'passw'
    post '/graphql', params: { query: mutation, variables: variables }

    json = JSON.parse(response.body)
    expect(json['data']['loginUser']).to include(
      'errors' => ['Invalid email or password']
    )
  end

  it 'should not log in a user with invalid email and password' do
    variables[:input][:email] = 'testexample.com'
    variables[:input][:password] = 'passw'
    post '/graphql', params: { query: mutation, variables: variables }

    json = JSON.parse(response.body)
    expect(json['data']['loginUser']).to include(
      'errors' => ["Invalid email or password"]
    )
  end

  it 'should not log in a user with invalid email and valid password' do
    variables[:input][:email] = 'testexample.com'
    post '/graphql', params: { query: mutation, variables: variables }

    json = JSON.parse(response.body)
    expect(json['data']['loginUser']).to include(
      'errors' => ['Invalid email or password']
    )
  end
end
