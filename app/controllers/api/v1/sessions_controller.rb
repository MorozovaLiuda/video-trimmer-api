class Api::V1::SessionsController < ApplicationController
  skip_before_action :is_resource_owner_authorized?

  # POST /sessions
  api :POST, '/sessions', 'Log in user'
  param :email, String
  param :password, String
  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      render status: :ok, json: { user_email: user.email, auth_token: user.auth_token }
    else
      render status: :unauthorized, json: { errors: 'Not authorized' }
    end
  end
end
