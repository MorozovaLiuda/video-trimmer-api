class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :is_resource_owner_authorized?
  rescue_from Mongoid::Errors::DocumentNotFound do
    render json: { error: 'Resource not found' }, status: :not_found
  end

  def is_resource_owner_authorized?
    return true if current_user

    render json: { errors: [{ detail: 'Access denied' }] }, status: :unauthorized
  end

  private

  def authenticate_token
    authenticate_or_request_with_http_token do |token, _options|
      User.find_by(auth_token: token)
    end
  end

  def current_user
    @current_user ||= authenticate_token
  end
end
