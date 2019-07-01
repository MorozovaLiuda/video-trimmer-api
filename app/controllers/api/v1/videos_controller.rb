class Api::V1::VideosController < ApplicationController
  before_action :find_video, only: %i[show update]

  api :GET, '/videos', 'Show current user videos'
  description 'Show current user videos'
  def index
    @videos = current_user.videos
  end

  api :POST, '/videos', 'Upload video'
  description 'Create video with specifed video params'
  param :video, Hash, desc: 'Video information' do
    param :file, String
    param :start_time, :number
    param :end_time, :number
  end
  def create
    video = current_user.videos.new(video_params)
    if video.save
      video.schedule!
      render json: { status: 'Scheduled' }, status: :ok
    else
      render json: { errors: video.errors.messages }, status: :unprocessable_entity
    end
  end

  api :PATCH, '/videos/:id', 'Restart failed videos'
  description 'Resume failed videos'
  param :video, Hash, desc: 'Video information' do
    param :id, :number
  end
  def update
    if @video.failed?
      @video.schedule!
      render json: { status: 'Scheduled' }, status: :ok
    else
      render json: { errors: "Can't restart video with #{@video.status} status" }, status: :unprocessable_entity
    end
  end

  private

  def video_params
    params.require(:video).permit(:file, :start_time, :end_time)
  end

  def find_video
    @video = current_user.videos.find(params[:id])
  end
end
