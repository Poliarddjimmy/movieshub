module Queries
  class FetchEpisode < BaseQuery
    type Types::EpisodeType, null: true

    argument :id, ID, required: true

    def resolve(id:)
      raise GraphQL::ExecutionError, "You need to authenticate to perform this action" unless context[:current_user]

      episode = Episode.find_by(id: id)
      raise GraphQL::ExecutionError, "Episode not found" unless episode

      episode
    end
  end
end
