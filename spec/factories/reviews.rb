FactoryBot.define do
  factory :review do
    content { "MyText" }
    reviewable { nil }
    user { build(:user) }
    rating { "1" }
  end
end
