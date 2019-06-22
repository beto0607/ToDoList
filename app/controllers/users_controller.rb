class UsersController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :find_user, except: %i[create index]
  before_action :logged_id?, only: [:update, :destroy]

  # GET /users
  def index
    render json: serialize_models(User.all),
           status: :ok
  end

  # GET /users/{username}
  def show
    render json: serialize_model(@user),
           status: :ok
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: serialize_model(@user),
             status: :created
    else
      render_errors(:unprocessable_entity, @user.errors)
    end
  end

  # PUT /users/{username}
  def update
    if @user.update(user_params)
      render json: serialize_model(@user),
             status: :ok
    else
      render_errors(:unprocessable_entity, @user.errors)
    end
  end

  # DELETE /users/{username}
  def destroy
    @user.destroy
  end

  private

  def find_user
    @user = User.find_by_id!(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_error(:not_found, "User not found", "User with id \"#{params[:id]}\" was not found.")
  end

  def user_params
    params.require(:user).permit(
      :name, :username, :email, :password, :password_confirmation
    )
  end

  def logged_id?
    if (@user == @current_user)
      true
    else
      render_error(:unauthorized, "Unnauthorized", "Token and ID are from differents users.")
    end
  end
end
