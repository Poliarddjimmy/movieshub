require 'rails_helper'

RSpec.describe MovieGenre, type: :model do
  let(:movie) { create(:movie) }
  let(:genre) { create(:genre) }

  context "validations" do
    it "is valid with valid attributes" do
      movie_genre = MovieGenre.new(movie: movie, genre: genre)
      expect(movie_genre).to be_valid
    end

    it "is not valid without a movie" do
      movie_genre = MovieGenre.new(movie: nil, genre: genre)
      expect(movie_genre).not_to be_valid
      expect(movie_genre.errors[:movie]).to include("can't be blank")
    end

    it "is not valid without a genre" do
      movie_genre = MovieGenre.new(movie: movie, genre: nil)
      expect(movie_genre).not_to be_valid
      expect(movie_genre.errors[:genre]).to include("can't be blank")
    end

    it "is not valid if the combination of movie and genre is not unique" do
      MovieGenre.create!(movie: movie, genre: genre) # First association
      duplicate_movie_genre = MovieGenre.new(movie: movie, genre: genre)

      expect(duplicate_movie_genre).not_to be_valid
      expect(duplicate_movie_genre.errors[:movie_id]).to include("Movie can only be assigned to this genre once")
    end
  end
end
