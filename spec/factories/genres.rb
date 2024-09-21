FactoryBot.define do
  factory :genre do
    name { "Comedy" }
    description { "A genre of humor" }
    slug { "comedy" }
    popularity { 8 }
    is_active { true }
    image_url { "http://example.com/comedy.jpg" }
  end
end
