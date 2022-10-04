class ApplicationController < ActionController::API
  before_action :set_current_user
  before_action :set_csrf_cookie
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection
  
  def require_authorization!
    if @current_user.nil?
      render json: nil, status: :unauthorized
    end
  end

  def set_auth_token(value)
    session[:authorization] = value
  end

  def auth_token
    session[:authorization]
  end

  def delete_auth_token(user)
    user.revoke_auth_token
    session[:authorization] = nil
  end

  def serialzed_errors(resource)
    {
      errors: resource.errors.full_messages
    }
  end

  private
  def set_current_user
    @current_user = User.find_by_auth_token(auth_token)
    if @current_user.present?
      delete_auth_token(@current_user)
      set_auth_token(@current_user.assign_auth_token)
    end
  end

  def set_csrf_cookie
    cookies["CSRF-TOKEN"] = {
         value: form_authenticity_token,
         domain: :all 
     }
 end
end
