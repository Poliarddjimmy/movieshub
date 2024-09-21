require 'rails_helper'

RSpec.describe Genre, type: :model do
  let(:valid_attributes) do
    {
      name: "Action",
      description: "Action movies are full of excitement and energy.",
      popularity: 10,
      is_active: true,
      image_url: "http://example.com/action.jpg"
    }
  end

  it "is valid with valid attributes" do
    genre = Genre.new(valid_attributes)
    expect(genre).to be_valid
  end

  # Name validation tests
  it "is invalid without a name" do
    genre = Genre.new(valid_attributes.merge(name: nil))
    expect(genre).not_to be_valid
    expect(genre.errors[:name]).to include("can't be blank")
  end

  it "is invalid with a non-unique name" do
    Genre.create!(valid_attributes)
    genre = Genre.new(valid_attributes)
    expect(genre).not_to be_valid
    expect(genre.errors[:name]).to include("has already been taken")
  end

  it "is invalid if the name is too short" do
    genre = Genre.new(valid_attributes.merge(name: "Ac"))
    expect(genre).not_to be_valid
    expect(genre.errors[:name]).to include("is too short (minimum is 3 characters)")
  end

  # Description validation tests
  it "is valid with an optional description" do
    genre = Genre.new(valid_attributes.merge(description: nil))
    expect(genre).to be_valid
  end

  it "is invalid if the description is too long" do
    genre = Genre.new(valid_attributes.merge(description: "A" * 501))
    expect(genre).not_to be_valid
    expect(genre.errors[:description]).to include("is too long (maximum is 500 characters)")
  end

  # Slug validation tests
  it "automatically generates a slug from the name" do
    genre = Genre.create!(valid_attributes)
    expect(genre.slug).to eq("action")
  end

  it "is invalid if popularity is negative" do
    genre = Genre.new(valid_attributes.merge(popularity: -1))
    expect(genre).not_to be_valid
    expect(genre.errors[:popularity]).to include("must be greater than or equal to 0")
  end

  # is_active validation tests
  it "is invalid if is_active is not true or false" do
    genre = Genre.new(valid_attributes.merge(is_active: nil))
    expect(genre).not_to be_valid
    expect(genre.errors[:is_active]).to include("is not included in the list")
  end

  # Image URL validation tests
  it "is valid with a valid image URL" do
    genre = Genre.new(valid_attributes)
    expect(genre).to be_valid
  end

  it "is invalid with an invalid image URL" do
    genre = Genre.new(valid_attributes.merge(image_url: "invalid_url"))
    expect(genre).not_to be_valid
    expect(genre.errors[:image_url]).to include("must be a valid URL")
  end
end
