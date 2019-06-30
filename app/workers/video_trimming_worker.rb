class VideoTrimmingWorker
  include Sidekiq::Worker

  def perform(id)
    VideoTrimming.new(id).process
  end
end
