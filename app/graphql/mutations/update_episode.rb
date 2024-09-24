module Mutations
  class UpdateEpisode < BaseMutation
    argument :id, ID, required: true
    argument :episode_number, String, required: false
    argument :title, String, required: false
    argument :description, String, required: false
    argument :duration, String, required: false
    argument :video_url, String, required: false

    field :episode, Types::EpisodeType, null: true
    field :errors, [String], null: false

    def resolve(id:, episode_number: nil, title: nil, description: nil, duration: nil, video_url: nil)
      raise GraphQL::ExecutionError, "You need to authenticate to perform this action" unless context[:current_user]

      episode = Episode.find_by(id: id)

      return { episode: nil, errors: ['Episode not found'] } unless episode

      episode.episode_number = episode_number if episode_number
      episode.title = title if title
      episode.description = description if description
      episode.duration = duration if duration
      episode.video_url = video_url if video_url

      if episode.save
        { episode: episode, errors: [] }
      else
        { episode: nil, errors: episode.errors.full_messages }
      end
    end
  end
end
