require 'rails_helper'

RSpec.describe "V1::Authorizations", type: :request do
  describe "POST /v1/authorization" do
    it "returns ok on valid attribtues" do
      user = FactoryBot.create(:user)
      post v1_authorization_path, params: {
        user:{
          email: user.email,
          password: "Password1"
        }
      }

      expect(response).to have_http_status(:ok)
      user.reload
      expect(user.authorization_token).to_not eq(nil)
    end

    it "returns not found on invalid attribtues" do
      user = FactoryBot.create(:user)
      post v1_authorization_path, params: {
        user:{
          email: user.email,
          password: "Passworsssd1"
        }
      }

      expect(response).to have_http_status(:not_found)
    end

    it "returns success on valid attribtues" do
      user = FactoryBot.create(:user)
      delete v1_authorization_path
      expect(response).to have_http_status(:ok)
      expect(user.authorization_token).to eq(nil)
    end
  end
end
