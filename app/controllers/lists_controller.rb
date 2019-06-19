class ListsController < ApplicationController
  before_action :set_list, only: [:show, :update, :destroy]
  before_action :authorize_request, only: [:create, :update, :destroy]
  before_action :find_user, only: [:create]
  before_action :check_if_owner, only: [:update, :destroy]
  # GET /lists or GET /user/:user_id/lists
  def index
    if (params[:user_id])
      find_user
      if (@user)
        render json: @user.lists
      end
    else
      render json: List.all
    end
  end

  # GET /lists/1
  def show
    render json: @list
  end

  # POST /users/:user_id/lists
  def create
    @list = List.new(list_params)
    @list.user = @user
    if @list.save
      render json: @list, status: :created, location: @list
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /lists/1
  def update
    if @list.update(list_params)
      render json: @list
    else
      render json: @list.errors, status: :unprocessable_entity
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
    render json: { errors: "List not found" }, status: :not_found
  end

  # Only allow a trusted parameter "white list" through.
  def list_params
    params.require(:list).permit(:title, :description, :due_date, :user_id)
  end

  def find_user
    @user = User.find_by_id!(params[:user_id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "User not found" }, status: :not_found
  end

  def check_if_owner
    if(@list.owner?(@current_user))then
        true
    else
        render json: { errors: "User is not the owner" }, status: :unauthorized
    end
  end
end
