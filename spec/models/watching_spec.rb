require 'rails_helper'

RSpec.describe Watching, type: :model do
  let(:user) { create(:user) }
  let(:movie) { create(:movie) }
  let(:profile) { create(:profile, user: user) }

  context "validations" do
    it "is valid with valid attributes" do
      watching = Watching.new(
        user: user,
        movie: movie,
        profile: profile,
        status: "watching",
        progress: 50
      )
      expect(watching).to be_valid
    end

    it "is invalid without a user" do
      watching = Watching.new(
        user: nil,
        movie: movie,
        profile: profile,
        status: "watching",
        progress: 50
      )
      expect(watching).to_not be_valid
      expect(watching.errors[:user]).to include("must exist")
    end

    it "is invalid without a movie" do
      watching = Watching.new(
        user: user,
        movie: nil,
        profile: profile,
        status: "watching",
        progress: 50
      )
      expect(watching).to_not be_valid
      expect(watching.errors[:movie]).to include("must exist")
    end

    it "is invalid without a profile" do
      watching = Watching.new(
        user: user,
        movie: movie,
        profile: nil,
        status: "watching",
        progress: 50
      )
      expect(watching).to_not be_valid
      expect(watching.errors[:profile]).to include("must exist")
    end

    it "is invalid without a status" do
      watching = Watching.new(
        user: user,
        movie: movie,
        profile: profile,
        status: nil,
        progress: 50
      )
      expect(watching).to_not be_valid
      expect(watching.errors[:status]).to include("can't be blank")
    end
  end

  context "enum status" do
    it "allows valid statuses" do
      valid_statuses = Watching.statuses.keys
      valid_statuses.each do |status|
        watching = Watching.new(
          user: user,
          movie: movie,
          profile: profile,
          status: status,
          progress: 50
        )
        expect(watching).to be_valid
      end
    end
  end
end
