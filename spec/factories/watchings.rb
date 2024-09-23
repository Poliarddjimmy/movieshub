FactoryBot.define do
  factory :watching do
    user { build(:user) }
    movie { build(:movie) }
    profile { build(:profile) }
    started_at { "2024-09-23 17:09:43" }
    finished_at { "2024-09-23 17:09:43" }
    progress { 1 }
    status { 0 }
  end
end
