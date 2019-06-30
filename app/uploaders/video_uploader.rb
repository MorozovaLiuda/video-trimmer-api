class VideoUploader < CarrierWave::Uploader::Base
  def store_dir
    # added dir for test only, assume that in production we will use cloud solutions
    "spec/support/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
