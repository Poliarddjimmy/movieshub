# frozen_string_literal: true

class User < ApplicationRecord
  has_many :profiles, dependent: :destroy
  has_many :watchings, dependent: :destroy

  has_secure_password

  validates_presence_of :email
  validates_uniqueness_of :email
  validates_format_of :email, with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates :password, presence: true, length: { minimum: 6 }

  after_validation :set_slug

  validate do |user|
      user.errors.add(:base, "The Password is Required") if user.password.blank?
      user.errors.add(:base, "The Password must be at least 6 characters") if user.password && user.password.length < 6
      user.errors.add(:base, "The first name is Required") if user.first_name.blank?
      user.errors.add(:base, "The last name is Required") if user.last_name.blank?
      user.errors.add(:base, "The email is Required") if user.email.blank?
      user.errors.add(:base, "The email is already taken") if User.where(email: user.email).exists?
  end

  def self.authenticate(email, password)
      user = User.find_by(email: email)
      if user && user.authenticate(password)
          return user
      else
          return false
      end
  end

  def full_name
      "#{self.first_name} #{self.last_name}"
  end

    #   can have only 10 profiles
    def can_create_profile?
        self.profiles.count < 10
    end

  private

  def parametrized_name
      full_name.parameterize if full_name
  end

  def set_slug
      token = [("a"..."z"), ("A"..."Z"), ("0"..."9")].map(&:to_a).flatten.map(&:to_s).freeze
      self.slug = "#{parametrized_name}-#{22.times.map { token.sample.downcase }.join}"
  end

end
