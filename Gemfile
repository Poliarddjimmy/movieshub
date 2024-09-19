source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.8", ">= 7.0.8.4"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

gem "graphql", "~> 1.6", ">= 1.6.6"
gem "rspec-graphql_response"

gem "graphql-batch", "~> 0.3.3"
# gem "graphql-preload"
# gem "optics-agent"

gem "json_web_token", "~> 0.3.5"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem "rack-cors"

gem "rubocop", "< 0.68"
gem "rubocop-github"

gem "rubocop-performance", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"



group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  # Call "byebug" anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "database_cleaner-active_record"
  gem "factory_bot_rails"
  gem "faker", "~> 1.8", ">= 1.8.4"
  gem "rails-controller-testing"
  gem "rspec-rails", "~> 5.0.0"
  gem "shoulda-matchers"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem "dotenv-rails", "~> 2.2", ">= 2.2.1"
  gem "graphiql-rails"
  gem "listen", ">= 3.0.5", "< 3.2"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"

  gem "web-console"
end
