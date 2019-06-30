require 'rails_helper'

describe Api::V1::UsersController do
  describe 'POST #create' do
    it 'creates user' do
      expect do
        post :create, format: :json, params: { user: { email: 'email@test.com', password: 'password' } }
      end.to change(User, :count).by(1)
      expect(response.status).to eq(200)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['auth_token']).to eq(User.last.auth_token)
    end
  end
end
