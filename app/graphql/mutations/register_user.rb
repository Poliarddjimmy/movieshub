# app/graphql/mutations/register_user.rb
module Mutations
  class RegisterUser < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true
    argument :first_name, String, required: true
    argument :last_name, String, required: true

    field :user, Types::UserType, null: true
    field :token, String, null: true
    field :errors, [String], null: false

    def resolve(email:, password:, first_name:, last_name:)
      begin
        user = User.create!(email: email, password: password, first_name: first_name, last_name: last_name)
        token = AuthToken.token(user)
        { user: user, token: token, errors: [] }
      rescue ActiveRecord::RecordInvalid => e
        # Handle validation errors
        { user: nil, token: nil, errors: e.record.errors.full_messages }
      rescue => e
        # Handle any other exceptions
        { user: nil, token: nil, errors: [e.message] }
      end
    end
  end
end
