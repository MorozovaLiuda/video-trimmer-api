require 'rails_helper'

describe User do
  describe 'validation' do
    it 'validates empty email' do
      user = build(:user, email: '')
      expect(user).to_not be_valid
    end

    it 'validates empty password' do
      user = build(:user, password: '')
      expect(user).to_not be_valid
    end
  end
end
