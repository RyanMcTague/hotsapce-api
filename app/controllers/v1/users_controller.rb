class V1::UsersController < ApplicationController
  before_action :require_authorization!, only: [
    :update,
    :destroy
  ]
  
  def create
    @user = User.new user_params
    if @user.save
      render json: serialized_user(@user), status: :ok
    else
      render json: serialzed_errors(@user), status: :unprocessable_entity
    end
  end

  def update
    if @current_user.update user_params
      render json: serialized_user(@current_user), status: :ok
    else
      render json: serialzed_errors(@current_user), status: :unprocessable_enitty
    end
  end

  def destroy
    delete_auth_token(@current_user)
    if @current_user.destroy
      render json: nil, status: :ok
    else
      render json: serialzed_errors(@current_user), status: :unprocessable_enitty
    end

  end

  private
  def serialized_user(user)
    {
      user: {
        id: user.to_param,
        email: user.email
      }
    }
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
