# app/graphql/mutations/update_profile.rb
module Mutations
  class UpdateProfile < Mutations::BaseMutation
    argument :id, ID, required: true
    argument :name, String, required: false

    field :profile, Types::ProfileType, null: true
    field :errors, [String], null: false

    def resolve(id:, name: nil)
      profile = Profile.find_by(id: id)

      if profile.nil?
        {
          profile: nil,
          errors: ['Profile not found']
        }
      else
        profile.update(name: name) if name.present?

        if profile.save
          {
            profile: profile,
            errors: []
          }
        else
          {
            profile: nil,
            errors: profile.errors.full_messages
          }
        end
      end
    end
  end
end
