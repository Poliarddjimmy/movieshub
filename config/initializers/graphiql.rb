# frozen_string_literal: true

if defined?(GraphiQL)
    GraphiQL::Rails.config.headers['Authorization'] = ->(context) {
      "Bearer #{ENV['JWT_TOKEN']}" # Ensure this environment variable is set
    }
  end
