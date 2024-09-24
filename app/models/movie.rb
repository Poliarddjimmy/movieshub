class Movie < ApplicationRecord
  has_many :movie_genres, dependent: :destroy
  has_many :reviews, as: :reviewable, dependent: :destroy
  has_many :seasons, dependent: :destroy

  validates :title, presence: true, length: { minimum: 3 }
  validates :plot, presence: true, length: { minimum: 10 }
  validates :synopsis, presence: true, length: { minimum: 10 }
  validates :actors, presence: true, length: { minimum: 1 }
  validates :release_year, presence: true, numericality: { only_integer: true }, numericality: { greater_than_or_equal_to: 1800 }
  validates :director, presence: true, length: { minimum: 3 }
  validates_presence_of :language, :duration, :rating, :poster_url
  validates :genres, presence: true, length: { minimum: 1 }#, inclusion: { in: ->(movie) { movie.genre_ids.map(&:to_i) } }

  enum rating: { G: 0, PG: 1, PG_13: 2, R: 3, NC_17: 4 }

  after_validation :set_slug
  after_create :create_movie_genres

  validate do |movie|
    movie.errors.add(:base, "The title is Required") if movie.title.blank?
    movie.errors.add(:base, "The title must be at least 3 characters") if movie.title && movie.title.length < 3
    movie.errors.add(:base, "The plot is Required") if movie.plot.blank?
    movie.errors.add(:base, "The plot must be at least 10 characters") if movie.plot && movie.plot.length < 10
    movie.errors.add(:base, "The synopsis is Required") if movie.synopsis.blank?
    movie.errors.add(:base, "The synopsis must be at least 10 characters") if movie.synopsis && movie.synopsis.length < 10
    movie.errors.add(:base, "The actors is Required") if movie.actors.blank?
    movie.errors.add(:base, "The actors must be at least 1 character") if movie.actors && movie.actors.length < 1
    movie.errors.add(:base, "The release year is Required") if movie.release_year.blank?
    movie.errors.add(:base, "The release year must be at least 1800") if movie.release_year && movie.release_year < 1800
    movie.errors.add(:base, "The director is Required") if movie.director.blank?
    movie.errors.add(:base, "The director must be at least 3 characters") if movie.director && movie.director.length < 3
    movie.errors.add(:base, "The language is Required") if movie.language.blank?
    movie.errors.add(:base, "The duration is Required") if movie.duration.blank?
    movie.errors.add(:base, "The rating is Required") if movie.rating.blank?
    movie.errors.add(:base, "The poster url is Required") if movie.poster_url.blank?
    movie.errors.add(:base, "The genres is Required") if movie.genres.blank?
    movie.errors.add(:base, "The genres must be at least 1 character") if movie.genres && movie.genres.length < 1
  end

  private

  def create_movie_genres
    genres.each do |genre_id|
      MovieGenre.create(movie_id: id, genre_id: genre_id)
    end
  end

  def parametrized_title
    title.parameterize if title
  end

  def set_slug
    token = [("a"..."z"), ("A"..."Z"), ("0"..."9")].map(&:to_a).flatten.map(&:to_s).freeze
    self.slug = "#{parametrized_title}-#{22.times.map { token.sample.downcase }.join}"
  end
end
