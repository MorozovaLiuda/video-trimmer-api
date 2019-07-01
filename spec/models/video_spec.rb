require 'rails_helper'

describe Video do
  let!(:video) { create(:video, user: create(:user)) }

  describe '#url' do
    it 'returns video url' do
      expect(video.url).to eq("/spec/support/uploads/video/file/#{video.id}/video.avi")
    end
  end

  describe '#title' do
    it 'returns video title' do
      expect(video.title).to eq('video.avi')
    end
  end

  describe '#duration' do
    it 'returns video title' do
      expect(video.duration).to eq(40)
    end
  end

  describe '#schedule!' do
    it 'changes status to scheduled' do
      video.schedule!
      expect(video.status).to eq('scheduled')
    end

    it 'schedules VideoTrimmingWorker' do
      expect do
        video.schedule!
      end.to change(VideoTrimmingWorker.jobs, :size).by(1)
    end
  end

  describe 'validation' do
    it 'validates empty file' do
      video = build(:video, file: '')
      expect(video).to_not be_valid
    end

    it 'validates empty end_time' do
      video = build(:video, end_time: nil)
      expect(video).to_not be_valid
    end

    it 'validates end_time greater than start_time' do
      video = build(:video, start_time: 10, end_time: 1)
      expect(video).to_not be_valid
    end

    it 'validates start_time greater than 0' do
      video = build(:video, start_time: -1)
      expect(video).to_not be_valid
    end
  end
end
