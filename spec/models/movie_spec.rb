# spec/models/movie_spec.rb
require 'rails_helper'

RSpec.describe Movie, type: :model do
  let(:valid_movie) do
    Movie.new(
      title: "Inception",
      plot: "A mind-bending thriller about entering dreams.",
      synopsis: "A skilled thief who steals corporate secrets by infiltrating the subconscious.",
      actors: ["Leonardo DiCaprio", "Joseph Gordon-Levitt"],
      release_year: 2010,
      director: "Christopher Nolan",
      language: "English",
      duration: 2,
      rating: :PG_13,
      poster_url: "http://example.com/inception.jpg",
      genres: [1, 2]
    )
  end

  describe "validations" do
    it "is valid with valid attributes" do
      expect(valid_movie).to be_valid
    end

    it "is invalid without a title" do
      valid_movie.title = nil
      expect(valid_movie).to_not be_valid
      expect(valid_movie.errors[:title]).to include("can't be blank")
    end

    it "is invalid if title is less than 3 characters" do
      valid_movie.title = "In"
      expect(valid_movie).to_not be_valid
      expect(valid_movie.errors[:title]).to include("is too short (minimum is 3 characters)")
    end

    it "is invalid without a plot" do
      valid_movie.plot = nil
      expect(valid_movie).to_not be_valid
      expect(valid_movie.errors[:plot]).to include("can't be blank")
    end

    it "is invalid if plot is less than 10 characters" do
      valid_movie.plot = "Too short"
      expect(valid_movie).to_not be_valid
      expect(valid_movie.errors[:plot]).to include("is too short (minimum is 10 characters)")
    end

    it "is invalid without a synopsis" do
      valid_movie.synopsis = nil
      expect(valid_movie).to_not be_valid
      expect(valid_movie.errors[:synopsis]).to include("can't be blank")
    end

    it "is invalid if synopsis is less than 10 characters" do
      valid_movie.synopsis = "Too short"
      expect(valid_movie).to_not be_valid
      expect(valid_movie.errors[:synopsis]).to include("is too short (minimum is 10 characters)")
    end

    it "is invalid without actors" do
      valid_movie.actors = []
      expect(valid_movie).to_not be_valid
      expect(valid_movie.errors[:actors]).to include("can't be blank")
    end

    it "is invalid without a release year" do
      valid_movie.release_year = nil
      expect(valid_movie).to_not be_valid
      expect(valid_movie.errors[:release_year]).to include("can't be blank")
    end

    it "is invalid if release year is before 1800" do
      valid_movie.release_year = 1799
      expect(valid_movie).to_not be_valid
      expect(valid_movie.errors[:release_year]).to include("must be greater than or equal to 1800")
    end

    it "is invalid without a director" do
      valid_movie.director = nil
      expect(valid_movie).to_not be_valid
      expect(valid_movie.errors[:director]).to include("can't be blank")
    end

    it "is invalid if director is less than 3 characters" do
      valid_movie.director = "AB"
      expect(valid_movie).to_not be_valid
      expect(valid_movie.errors[:director]).to include("is too short (minimum is 3 characters)")
    end

    it "is invalid without a language" do
      valid_movie.language = nil
      expect(valid_movie).to_not be_valid
      expect(valid_movie.errors[:language]).to include("can't be blank")
    end

    it "is invalid without a duration" do
      valid_movie.duration = nil
      expect(valid_movie).to_not be_valid
      expect(valid_movie.errors[:duration]).to include("can't be blank")
    end

    it "is invalid without a rating" do
      valid_movie.rating = nil
      expect(valid_movie).to_not be_valid
      expect(valid_movie.errors[:rating]).to include("can't be blank")
    end

    it "is invalid without a poster_url" do
      valid_movie.poster_url = nil
      expect(valid_movie).to_not be_valid
      expect(valid_movie.errors[:poster_url]).to include("can't be blank")
    end

    it "is invalid without genres" do
      valid_movie.genres = []
      expect(valid_movie).to_not be_valid
      expect(valid_movie.errors[:genres]).to include("can't be blank")
    end
  end

  describe "#set_slug" do
    it "sets a unique slug for the movie before saving" do
      valid_movie.save
      expect(valid_movie.slug).to match(/inception-\w+/)
    end
  end
end
