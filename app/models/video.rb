class Video
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum

  field :file, type: String
  field :start_time, type: Integer, default: 0
  field :end_time, type: Integer
  field :status, type: String, default: ''

  validates :start_time, numericality: { greater_than_or_equal_to: 0 }
  validates :end_time, numericality: { greater_than: :start_time }

  belongs_to :user

  enum status: %w[scheduled processing done failed]

  mount_uploader :file, VideoUploader

  delegate :url, to: :file

  def title
    file.path.split('/').last
  end

  def duration
    end_time - start_time
  end

  def schedule!
    scheduled!
    VideoTrimmingWorker.perform_async(id.to_s)
  end
end
