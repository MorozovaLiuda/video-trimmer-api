Apipie.configure do |config|
  config.app_name                = 'VideoTrimmerApi'
  config.api_base_url            = 'api/v1'
  config.doc_base_url            = '/apipie'
  # were is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/v1/*.rb"
  config.default_version = '1'
  config.translate = false
end
