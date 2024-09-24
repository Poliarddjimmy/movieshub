class Episode < ApplicationRecord
  belongs_to :season

  validates :episode_number, presence: true
  validates :title, presence: true
  validates :duration, presence: true
  validates :video_url, presence: true, format: { with: URI::regexp(%w[http https]), message: 'must be a valid URL' }#, allow_blank: true
end
