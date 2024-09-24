require 'rails_helper'

RSpec.describe Season, type: :model do
  let(:movie) { create(:movie) }  # Assumes you have a Movie factory

  subject {
    described_class.new(
      season_number: season_number,
      title: title,
      description: description,
      movie: movie
    )
  }

  let(:season_number) { 1 }
  let(:title) { "Season 1" }
  let(:description) { "This is the first season." }

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a season number' do
      subject.season_number = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:season_number]).to include("can't be blank")
    end

    it 'is not valid without a title' do
      subject.title = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:title]).to include("can't be blank")
    end

    it 'is valid with a description that is at most 250 characters' do
      subject.description = 'A' * 250
      expect(subject).to be_valid
    end

    it 'is not valid with a description that exceeds 250 characters' do
      subject.description = 'A' * 251
      expect(subject).not_to be_valid
      expect(subject.errors[:description]).to include('is too long (maximum is 250 characters)')
    end
  end

  context 'associations' do
    it 'belongs to a movie' do
      association = described_class.reflect_on_association(:movie)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'has many episodes' do
      association = described_class.reflect_on_association(:episodes)
      expect(association.macro).to eq(:has_many)
    end
  end
end
