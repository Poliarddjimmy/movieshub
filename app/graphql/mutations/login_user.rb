module Mutations
  class LoginUser < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true

    field :user, Types::UserType, null: true
    field :token, String, null: true
    field :refresh_token, String, null: true
    field :errors, [String], null: false

    def resolve(email:, password:)
      begin
        user = User.authenticate(email, password)
        if user
          token = AuthToken.token(user)
          refresh_token = AuthToken.token(user, 1.hour.from_now.to_i)
          { user: user, token: token, refresh_token: refresh_token, errors: [] }
        else
          { user: nil, token: nil, refresh_token: nil, errors: ["Invalid email or password"] }
        end
      rescue => e
        # Handle any other exceptions that might occur
        { user: nil, token: nil, refresh_token: nil, errors: [e.message] }
      end
    end
  end
end
