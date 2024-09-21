FactoryBot.define do
  factory :movie do
    title { "MyString" }
    plot { "MyText Plot" }
    synopsis { "MyText synopsis" }
    actors { ["MyString"] }
    release_year { 1900 }
    director { "MyString" }
    language { "MyString" }
    duration { "MyString" }
    rating { 1 }
    poster_url { "MyString" }
    genres { [1, 2] }
  end
end
