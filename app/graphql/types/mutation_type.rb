module Types
  class MutationType < Types::BaseObject
    field :update_genre, mutation: Mutations::UpdateGenre
    field :create_genre, mutation: Mutations::CreateGenre

    field :login_user, mutation: Mutations::LoginUser
    field :register_user, mutation: Mutations::RegisterUser

    field :create_profile, mutation: Mutations::CreateProfile
    field :update_profile, mutation: Mutations::UpdateProfile

    field :create_movie, mutation: Mutations::CreateMovie
    field :update_movie, mutation: Mutations::UpdateMovie
  end
end
