require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end

  it "is invalid with invalid email" do
    user = FactoryBot.build(:user, :with_invalid_email)
    expect(user).to_not be_valid
  end

  it "is invalid with invalid password" do
    user = FactoryBot.build(:user, :with_invalid_password)
    expect(user).to_not be_valid
  end

  it "is invalid with invalid password confirmation" do
    user = FactoryBot.build(:user, :with_invalid_confirmation)
    expect(user).to_not be_valid
  end

  it "saves a json web token" do
    user = FactoryBot.create(:user)
    user.assign_auth_token
    data = JWT.decode(user.authorization_token, Rails.configuration.secrets.jwt_secret).first
    expect(data["id"]).to eq(user.id)
  end

  it "revokes json web token" do
    user = FactoryBot.create(:user)
    user.assign_auth_token
    expect(user.authorization_token).to_not eq(nil)
    user.revoke_auth_token
    expect(user.authorization_token).to eq(nil)
  end

  it "finds a user by json web token" do
    user = FactoryBot.create(:user)
    user.assign_auth_token
    found_user = User.find_by_auth_token(user.authorization_token)
    expect(user).to eq(found_user)
  end
end
