require 'rails_helper'

describe Api::V1::SessionsController do
  describe 'POST #create' do
    it 'authorizes user' do
      user = User.create(email: 'test@test.com', password: '123asdQQ')
      post :create, format: :json, params: { email: user.email, password: '123asdQQ' }
      expect(response.status).to eq(200)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.values_at('user_email', 'auth_token')).to eq([user.email, user.auth_token])
    end

    it 'returns error if user not authorized' do
      user = User.create(email: 'test@test.com', password: 'invalid password')
      post :create, format: :json, params: { email: user.email, password: '123asdQQ' }
      expect(response.status).to eq(401)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['errors']).to eq('Not authorized')
    end
  end
end
