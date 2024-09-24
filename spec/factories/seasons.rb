FactoryBot.define do
  factory :season do
    movie { build(:movie) }
    season_number { "1" }
    title { "MyString" }
    description { "MyText" }
  end
end
