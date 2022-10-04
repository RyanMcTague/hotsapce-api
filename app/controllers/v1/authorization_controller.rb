class V1::AuthorizationController < ApplicationController
  
  def create
    email = authorization_params[:email]
    email = email.downcase if email.present?
    @user = User.find_by(email: email)

    if @user.present? && @user.authenticate(authorization_params[:password])
      set_auth_token(@user.assign_auth_token)
      render json: serialized_user(@user), status: :ok
    else
      render json: nil, status: :not_found
    end
  end

  def destroy
    cookies.delete "CSRF-TOKEN"
    delete_auth_token(@current_user) if @current_user.present?
    render json: nil, status: :ok
  end


  private
  def serialized_user(user)
    {
      user:{
        id: user.to_param,
        email: user.email
      }
    }
  end

  def authorization_params
    params.require(:user).permit(:email, :password)
  end
end
