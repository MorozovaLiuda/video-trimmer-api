class Api::V1::UsersController < ApplicationController
  skip_before_action :is_resource_owner_authorized?

  api :POST, '/users', 'Create user'
  param :video, Hash, desc: 'User information' do
    param :email, String
    param :password, String
  end
  def create
    user = User.create(user_params)
    render status: :ok, json: { auth_token: user.auth_token }
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
