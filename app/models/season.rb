class Season < ApplicationRecord
  belongs_to :movie
  has_many :episodes, dependent: :destroy

  validates :season_number, presence: true
  validates :title, presence: true
  validates :description, presence: false, length: { maximum: 250 }
end
