module Mutations
  class CreateGenre < Mutations::BaseMutation
    argument :name, String, required: true
    argument :description, String, required: false
    argument :popularity, Integer, required: false
    argument :image_url, String, required: false

    field :genre, Types::GenreType, null: true
    field :errors, [String], null: false

    def resolve(name:, description: nil, popularity: nil, image_url: nil)
      raise GraphQL::ExecutionError, "not authorized" unless context[:current_user]

      begin
        attributes = { name: name, description: description, popularity: popularity.to_i, image_url: image_url }
        genre = Genre.create!(attributes)

        { genre: genre, errors: [] }.as_json(root: false)

      rescue ActiveRecord::RecordInvalid => e
        { genre: nil, errors: [e.message] }.as_json(root: false)
      end
    end
  end
end
