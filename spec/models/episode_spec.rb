require 'rails_helper'

RSpec.describe Episode, type: :model do
  let(:season) { create(:season) }

  describe 'associations' do
    it { should belong_to(:season) }
  end

  describe 'validations' do
    subject { build(:episode, season: season) } # Building an episode with a valid season

    it { should validate_presence_of(:episode_number) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:duration) }
    it { should validate_presence_of(:video_url) }

    it 'validates format of video_url' do
      subject.video_url = 'invalid_url'
      expect(subject).not_to be_valid
      expect(subject.errors[:video_url]).to include('must be a valid URL')

      subject.video_url = 'http://example.com/video.mp4'
      expect(subject).to be_valid

      subject.video_url = 'https://example.com/video.mp4'
      expect(subject).to be_valid
    end
  end
end
