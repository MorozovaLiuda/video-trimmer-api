class VideoTrimming
  def initialize(id)
    @video = Video.find(id)
  end

  def process
    return unless @video.failed?

    sleep 10
    rand(2) > 0
  end
end
