FactoryBot.define do
  factory :profile do
    name { "MyString" }
    user { build(:user) }
  end
end
