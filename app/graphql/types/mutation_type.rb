module Types
  class MutationType < Types::BaseObject
    field :create_profile, mutation: Mutations::CreateProfile
    field :login_user, mutation: Mutations::LoginUser
    field :register_user, mutation: Mutations::RegisterUser
    field :update_profile, mutation: Mutations::UpdateProfile
  end
end
