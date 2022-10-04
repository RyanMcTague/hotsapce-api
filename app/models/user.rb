class User < ApplicationRecord
  has_secure_password

  validates :email, 
    presence: true,
    uniqueness: { case_sensitive: false }, 
    format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password, 
    presence: true, 
    length: { minimum: 7 }, 
    if: -> { self.password.present? || self.id.nil? }

  before_save if: -> { self.email.present? } do
    self.email = self.email.downcase
  end

  def assign_auth_token
    now = DateTime.now.to_i
    payload = { 
      id: self.id,
      iss: now,
      exp: now + (60 * 60)
    }
    token = JWT.encode(payload, Rails.configuration.secrets.jwt_secret)
    self.update(authorization_token: token)
    token
  end

  def self.find_by_auth_token(token)
    begin
      data = JWT.decode(token, Rails.configuration.secrets.jwt_secret).first
      user= User.find(data['id'])
      return if user.nil?
      if data['exp'].to_i <= DateTime.now.to_i
        user.revoke_auth_token
        return
      end
      return user if user.present? && user.authorization_token == token
    rescue
      nil
    end
  end

  def revoke_auth_token
    self.update(authorization_token: nil)
  end
end
