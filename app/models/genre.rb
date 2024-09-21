class Genre < ApplicationRecord
  # Associations
  has_many :movie_genres, dependent: :destroy
  has_many :movies, through: :movie_genres

  # Validations
  validates :name, presence: true, uniqueness: true, length: { minimum: 3 }
  validates :description, length: { maximum: 500 }, allow_blank: true
  validates :slug, presence: true, uniqueness: true
  validates :popularity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :is_active, inclusion: { in: [true, false] }
  validates :image_url, format: { with: URI::regexp(%w[http https]), message: 'must be a valid URL' }, allow_blank: true

  # Callbacks
  before_validation :set_slug#, if: :name_changed?

  private

  # Generates a URL-friendly slug based on the genre name
  def set_slug
    self.slug = name.parameterize if name.present?
  end
end
