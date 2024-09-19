# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  # Validations
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should allow_value('test@example.com').for(:email) }
  it { should_not allow_value('invalidemail').for(:email) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_length_of(:password).is_at_least(6) }

  # Custom Validations
  describe 'custom validations' do
    let(:user) { User.new(email: 'test@example.com', password: 'password', first_name: 'John', last_name: 'Doe') }

    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is invalid without a password' do
      user.password = nil
      expect(user).to_not be_valid
      expect(user.errors[:base]).to include('The Password is Required')
    end

    it 'is invalid with a password shorter than 6 characters' do
      user.password = 'short'
      expect(user).to_not be_valid
      expect(user.errors[:base]).to include('The Password must be at least 6 characters')
    end

    it 'is invalid without a first name' do
      user.first_name = nil
      expect(user).to_not be_valid
      expect(user.errors[:base]).to include('The first name is Required')
    end

    it 'is invalid without a last name' do
      user.last_name = nil
      expect(user).to_not be_valid
      expect(user.errors[:base]).to include('The last name is Required')
    end

    it 'is invalid without an email' do
      user.email = nil
      expect(user).to_not be_valid
      expect(user.errors[:base]).to include('The email is Required')
    end

    it 'is invalid with a taken email' do
      User.create(email: 'test@example.com', password: 'password', first_name: 'John', last_name: 'Doe')
      expect(user).to_not be_valid
      expect(user.errors[:base]).to include('The email is already taken')
    end
  end

  # Methods
  describe '#full_name' do
    let(:user) { User.new(first_name: 'John', last_name: 'Doe') }

    it 'returns the full name' do
      expect(user.full_name).to eq('John Doe')
    end
  end

  describe '#set_slug' do
    it 'sets a slug after validation' do
      user = User.create(email: 'test@example.com', password: 'password', first_name: 'John', last_name: 'Doe')
      expect(user.slug).to match(/\Ajohn-doe-[a-z0-9]{22}\z/)
    end
  end

  # Class Methods
  describe '.authenticate' do
    let!(:user) { User.create(email: 'test@example.com', password: 'password', first_name: 'John', last_name: 'Doe') }

    it 'returns the user when authentication is successful' do
      expect(User.authenticate('test@example.com', 'password')).to eq(user)
    end

    it 'returns false when authentication fails' do
      expect(User.authenticate('test@example.com', 'wrongpassword')).to be_falsey
    end
  end
end
