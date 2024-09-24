module Mutations
  class CreateEpisode < BaseMutation
    argument :season_id, ID, required: true
    argument :episode_number, String, required: true
    argument :title, String, required: true
    argument :description, String, required: false
    argument :duration, String, required: true
    argument :video_url, String, required: true

    field :episode, Types::EpisodeType, null: true
    field :errors, [String], null: false

    def resolve(season_id:, episode_number:, title:, description: nil, duration:, video_url:)
      raise GraphQL::ExecutionError, "You need to authenticate to perform this action" unless context[:current_user]

      episode = Episode.new(
        season_id: season_id,
        episode_number: episode_number,
        title: title,
        description: description,
        duration: duration,
        video_url: video_url
      )

      if episode.save
        { episode: episode, errors: [] }
      else
        { episode: nil, errors: episode.errors.full_messages }
      end
    end
  end
end
