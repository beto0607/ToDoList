class Authentication
  attr_accessor :user, :token, :exp, :id
end

class AuthenticationController < ApplicationController

  # POST /auth/login
  # @parms {auth:{:email,:password}}
  def login
    @user = User.find_by_email(params[:auth][:email])
    if @user&.authenticate(params[:auth][:password])
      obj = Authentication.new
      obj.token = JsonWebToken.encode(user_id: @user.id)
      obj.user = @user
      obj.exp = (Time.now + 24.hours.to_i).strftime("%m-%d-%Y %H:%M")
      render json: serialize_model(obj, include: ["user"]),
             status: :ok
    else
      render_error(:unauthorized, "Unauthorized", "Email or password invalid.")
    end
  end
end
