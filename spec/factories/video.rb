FactoryBot.define do
  factory :video do
    file { Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, 'spec/fixtures/files/video.avi')), 'video/mpeg') }
    end_time { 40 }
  end
end
