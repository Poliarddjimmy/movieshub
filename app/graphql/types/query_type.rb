module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :fetch_profile, resolver: Queries::FetchProfile
    field :fetch_profiles, resolver: Queries::FetchProfiles

    field :fetch_movies, resolver: Queries::FetchMovies
    field :fetch_movie, resolver: Queries::FetchMovie

    field :fetch_genres, resolver: Queries::FetchGenres
    field :fetch_genre, resolver: Queries::FetchGenre

    field :watchings, resolver: Queries::Watchings
  end
end
