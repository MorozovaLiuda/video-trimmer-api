require 'rails_helper'

describe Api::V1::VideosController do
  render_views
  let!(:user) { create(:user, :with_videos) }

  before do
    request.headers['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(user.auth_token)
  end

  describe 'GET #index' do
    it 'returns all videos for current user' do
      get :index, format: :json
      expect(response.status).to eq(200)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.size).to eq(user.videos.count)
    end
  end

  describe 'POST #create' do
    let(:file) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'video.avi'), 'video/mpeg').to_s }

    it 'creates video for current user' do
      expect do
        post :create, format: :json, params: { video: { file: file, start_time: 0, end_time: 40 } }
      end.to change(user.videos, :count).by(1)
      expect(response.status).to eq(200)
    end

    it 'schedules video trimming' do
      expect do
        post :create, format: :json, params: { video: { file: file, start_time: 0, end_time: 40 } }
      end.to change(VideoTrimmingWorker.jobs, :size).by(1)
    end
  end

  describe 'GET #show' do
    it 'returns particular video for current user' do
      get :show, format: :json, params: { id: user.videos.last.id }
      expect(response.status).to eq(200)
      video = assigns[:video]
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.values_at('duration', 'url')).to eq([video.duration, video.url])
    end
  end

  describe 'PUT #update' do
    let(:video) { user.videos.last }

    it 'resumes failed videos' do
      video.failed!
      put :update, format: :json, params: { id: video.id }
      expect(response.status).to eq(200)
      expect(video.reload.scheduled?).to be true
    end

    it 'schedules video trimming' do
      video.failed!
      expect do
        put :update, format: :json, params: { id: video.id }
      end.to change(VideoTrimmingWorker.jobs, :size).by(1)
    end

    it 'does not resume not failed videos' do
      expect do
        put :update, format: :json, params: { id: video.id }
      end.not_to change(VideoTrimmingWorker.jobs, :size)
      expect(response.status).to eq(422)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['errors']).to eq("Can't restart video with #{video.status} status")
    end
  end
end
