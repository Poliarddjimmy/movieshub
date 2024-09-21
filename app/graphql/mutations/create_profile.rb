# app/graphql/mutations/create_profile.rb
module Mutations
  class CreateProfile < Mutations::BaseMutation
    argument :name, String, required: true
    argument :user_id, ID, required: true

    field :profile, Types::ProfileType, null: true
    field :errors, [String], null: false

    def resolve(name:, user_id:)
      raise GraphQL::ExecutionError, "not authorized" unless context[:current_user]

      begin
        if (user = User.find_by(id: user_id)).nil?
          { profile: nil, errors: ['User not found'] }
        else
          if user.profiles.include?(profile = Profile.where(user: user).where(name: name).first)
            { profile: nil, errors: ['The user already has a profile with the name'] }
          else
            if user.can_create_profile?
              profile = Profile.new(name: name, user: user)
              if profile.save
                { profile: profile, errors: [] }
              else
                { profile: nil, errors: profile.errors.full_messages }
              end
            else
              { profile: nil, errors: ['The user already has ten profiles'] }
            end
          end
        end
      rescue ActiveRecord::RecordInvalid => e
        { profile: nil, errors: [e.message] }
      end

    end
  end
end
