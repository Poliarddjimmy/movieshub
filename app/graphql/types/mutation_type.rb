module Types
  class MutationType < Types::BaseObject
    field :delete_episode, mutation: Mutations::DeleteEpisode
    field :update_episode, mutation: Mutations::UpdateEpisode
    field :create_episode, mutation: Mutations::CreateEpisode
    field :delete_season, mutation: Mutations::DeleteSeason
    field :update_season, mutation: Mutations::UpdateSeason
    field :create_season, mutation: Mutations::CreateSeason
    field :delete_review, mutation: Mutations::DeleteReview
    field :update_review, mutation: Mutations::UpdateReview
    field :create_review, mutation: Mutations::CreateReview
    field :update_watching, mutation: Mutations::UpdateWatching
    field :create_watching, mutation: Mutations::CreateWatching
    field :delete_movie_genre, mutation: Mutations::DeleteMovieGenre
    field :create_movie_genre, mutation: Mutations::CreateMovieGenre

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
