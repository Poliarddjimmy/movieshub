FactoryBot.define do
  factory :episode do
    season { build(:season) }
    episode_number { "1" }
    title { "New episode" }
    description { "This is a new episode" }
    duration { "30" }
    video_url { "http://example.com/video1.mp4" }
  end
end
