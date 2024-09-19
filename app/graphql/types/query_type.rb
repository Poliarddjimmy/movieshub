module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField


    field :fetch_profile, resolver: Queries::FetchProfile
    field :fetch_profiles, resolver: Queries::FetchProfiles
  end
end
