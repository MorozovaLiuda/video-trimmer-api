class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  field :auth_token, type: String
  field :email, type: String
  field :password_digest, type: String

  validates :email, presence: true

  has_secure_password

  before_create :generate_auth_token

  has_many :videos, dependent: :destroy

  private

  def generate_auth_token
    self.auth_token = SecureRandom.hex
  end
end
