# spec/models/profile_spec.rb
require 'rails_helper'

RSpec.describe Profile, type: :model do
  let(:user) { User.create(first_name: "John", last_name: "Doe", email: "john.doe@example.com", password: "password") }

  describe "validations" do
    context "when name is present and valid" do
      it "is valid with a name that has 3 or more characters" do
        profile = Profile.new(name: "Jane", user: user)
        expect(profile).to be_valid
      end
    end

    context "when name is absent" do
      it "is not valid without a name" do
        profile = Profile.new(name: "", user: user)
        expect(profile).to_not be_valid
        expect(profile.errors[:base]).to include("The name is Required")
      end
    end

    context "when name is too short" do
      it "is not valid with a name shorter than 3 characters" do
        profile = Profile.new(name: "Jo", user: user)
        expect(profile).to_not be_valid
        expect(profile.errors[:base]).to include("The name must be at least 3 characters")
      end
    end

    context "when name is exactly 3 characters" do
      it "is valid with a name of exactly 3 characters" do
        profile = Profile.new(name: "Ana", user: user)
        expect(profile).to be_valid
      end
    end

    it { should belong_to(:user) }
  end
end
