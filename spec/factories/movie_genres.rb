FactoryBot.define do
  factory :movie_genre do
    movie { build(:movie) }
    genre { build(:genre) }
  end
end
