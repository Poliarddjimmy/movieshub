FactoryBot.define do
  factory :movie do
    title { "Inception" }
    plot { "A mind-bending thriller about entering dreams." }
    synopsis { "A skilled thief who steals corporate secrets by infiltrating the subconscious." }
    actors { ["Leonardo DiCaprio", "Joseph Gordon-Levitt"] }
    release_year { 2010 }
    director { "Christopher Nolan" }
    language { "English" }
    duration { 2 }
    rating { :PG_13 }
    poster_url { "http://example.com/inception.jpg" }
    genres { [1, 2] }
    is_active { true }
  end
end
