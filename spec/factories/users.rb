FactoryBot.define do
  factory :user do
    first_name { "Djimmy" }
    last_name { "Poliard" }
    slug { "djimmy-poliard-1234567890" }
    email { "email@test.com" }
    password { "23jim0488" }
  end
end
