class ListsController < ApplicationController
  before_action :authorize_request
  before_action :set_list, only: [:show, :update, :destroy]
  before_action :find_user, only: [:create]
  before_action :check_if_owner, only: [:show, :update, :destroy]
  before_action :check_user_id_and_current_user, only: [:create]
  # GET /user/:user_id/lists
  def index
    if (params[:user_id])
      find_user
      if (@user)
        render json: serialize_models(@user.lists),
               status: :ok
      end
    end
  end

  # GET /lists/1
  def show
    render json: serialize_model(@list, include: ["items", "comments"]),
           status: :ok
  end

  # POST /users/:user_id/lists
  def create
    @list = List.new(list_params)
    @list.user = @user
    if @list.save
      render json: serialize_model(@list),
             status: :created
    else
      render_errors(:unprocessable_entity, @list.errors)
    end
  end

  # PATCH/PUT /lists/1
  def update
    if @list.update(list_params)
      render json: serialize_model(@list),
             status: :ok
    else
      render_errors(:unprocessable_entity, @list.errors)
    end
  end

  # DELETE /lists/1
  def destroy
    @list.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_list
    @list = List.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_error(:not_found, "List not found", "List with id \"#{params[:id]}\" was not found.")
  end

  # Only allow a trusted parameter "white list" through.
  def list_params
    params.require(:list).permit(:title, :description, :due_date, :user_id)
  end

  def find_user
    @user = User.find_by_id!(params[:user_id])
  rescue ActiveRecord::RecordNotFound
    render_error(:not_found, "User not found", "User with id \"#{params[:user_id]}\" was not found.")
  end

  def check_if_owner
    if (@list.owner?(@current_user))
      true
    else
      render_error(:unauthorized, "User is not the owner", "User with id \"#{params[:user_id]}\" is not the owner of this list.")
    end
  end

  def check_user_id_and_current_user
    if (@current_user.id == @user.id)
      true
    else
      render_error(:unauthorized, "Unnauthorized", "Token and ID are from differents users.")
    end
  end
end
