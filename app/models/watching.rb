class Watching < ApplicationRecord
  belongs_to :user
  belongs_to :movie
  belongs_to :profile

  enum status: { watching: 0, completed: 1, dropped: 2, on_hold: 3 }

  # validates :user, :movie, :profile, presence: true
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :progress, presence: true
end
