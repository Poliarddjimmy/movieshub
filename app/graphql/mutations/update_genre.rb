module Mutations
  class UpdateGenre < Mutations::BaseMutation
    argument :id, ID, required: true
    argument :name, String, required: false
    argument :description, String, required: false
    argument :popularity, Integer, required: false
    argument :is_active, Boolean, required: false
    argument :image_url, String, required: false

    field :genre, Types::GenreType, null: true
    field :errors, [String], null: false

    def resolve(id:, name: nil, description: nil, popularity: nil, is_active: nil, image_url: nil)
      raise GraphQL::ExecutionError, "not authorized" unless context[:current_user]

      genre = Genre.find_by(id: id)

      begin
        if genre.nil?
          raise GraphQL::ExecutionError, "Genre not found"
        end

        if name
          genre.name = name
        end
        if description
          genre.description = description
        end
        if popularity
          genre.popularity = popularity
        end
        if is_active != nil
          genre.is_active = is_active
        end
        if image_url
          genre.image_url = image_url
        end

        if genre.save
          { genre: genre, errors: [] }
        else
          { genre: nil, errors: genre.errors.full_messages }
        end
      rescue ActiveRecord::RecordInvalid => e
        { genre: nil, errors: [e.message] }
      end
    end
  end
end
