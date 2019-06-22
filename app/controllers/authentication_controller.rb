class AuthenticationController < ApplicationController
  before_action :authorize_request, except: :login

  # POST /auth/login
  def login
    @user = User.find_by_email(params[:auth][:email])
    if @user&.authenticate(params[:auth][:password])
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      render json: {
               token: token,
               exp: time.strftime("%m-%d-%Y %H:%M"),
               username: @user.username,
               user_id: @user.id,
             }, status: :ok
    else
      render json: { error: "unauthorized" }, status: :unauthorized
    end
  end

  private

  def login_params
    params.require(:auth).permit(:email, :password)
  end
end
