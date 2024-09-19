class Profile < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, length: { minimum: 3 }

  validate do |profile|
    profile.errors.add(:base, "The name is Required") if profile.name.blank?
    profile.errors.add(:base, "The name must be at least 3 characters") if profile.name && profile.name.length < 3
  end

end
