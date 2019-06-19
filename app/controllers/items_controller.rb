class ItemsController < ApplicationController
  before_action :authorize_request
  before_action :set_item, only: [:update, :destroy, :resolve, :unsolve]
  before_action :set_list, only: [:index, :create]
  before_action :check_list_owner

  # GET /lists/1/items
  def index
    render json: @list.items
  end

  # POST /lists/1/items
  def create
    @item = Item.new(item_params)
    @item.list_id = @list.id
    if @item.save
      render json: @item, status: :created
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /items/1
  def update
    if @item.update(item_params)
      render json: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /items/1
  def destroy
    @item.destroy
  end

  # PATCH/PUT /items/1/resolve
  def resolve
    if @item.update(status: "DONE")
      render json: {item: @item}
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /items/1/resolve
  def unsolve
    if @item.update(status: "ACTIVE") then
        render json: {item: @item}, status: :ok
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id] || params[:item_id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "Item not found" }, status: :not_found
  end

  # Only allow a trusted parameter "white list" through.
  def item_params
    params.require(:item).permit(:title, :description, :status, :due_date, :list_id)
  end

  def set_list
    @list = List.find(params[:list_id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "List not found" }, status: :not_found
  end

  def check_list_owner
    if (!((@list && @list.owner?(@current_user)) || (@item && @item.list.owner?(@current_user))))then
      render json: { errors: "User must be the list's owner" }, status: :unauthorized
    end
  end
end
