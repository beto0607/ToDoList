class ItemsController < ApplicationController
  before_action :authorize_request
  before_action :set_item, only: [:update, :destroy, :resolve, :unsolve]
  before_action :set_list, only: [:index, :create]
  before_action :check_list_owner

  # GET /lists/1/items
  def index
    render json: serialize_models(@list.items),
           status: :ok
  end

  # POST /lists/1/items
  def create
    @item = Item.new(item_params)
    @item.list_id = @list.id
    if @item.save
      render json: serialize_model(@item),
             status: :created
    else
      render_errors(:unprocessable_entity, @item.errors)
    end
  end

  # PATCH/PUT /items/1
  def update
    if @item.update(item_params)
      render json: serialize_model(@item),
             status: :ok
    else
      render_errors(:unprocessable_entity, @item.errors)
    end
  end

  # DELETE /items/1
  def destroy
    @item.destroy
  end

  # PATCH/PUT /items/1/resolve
  def resolve
    if @item.update(status: "DONE")
      render json: serialize_model(@item),
             status: :ok
    else
      render_errors(:unprocessable_entity, @item.errors)
    end
  end

  # PATCH/PUT /items/1/resolve
  def unsolve
    if @item.update(status: "ACTIVE")
      render json: serialize_model(@item),
             status: :ok
    else
      render_errors(:unprocessable_entity, @item.errors)
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id] || params[:item_id])
  rescue ActiveRecord::RecordNotFound
    render_error(:not_found, "Item not found", "Item with id \"#{params[:id] || params[:item_id]}\" was not found.")
  end

  # Only allow a trusted parameter "white list" through.
  def item_params
    params.require(:item).permit(:title, :description, :status, :due_date, :list_id)
  end

  def set_list
    @list = List.find(params[:list_id])
  rescue ActiveRecord::RecordNotFound
    render_error(:not_found, "List not found", "List with id \"#{params[:list_id]}\" was not found.")
  end

  def check_list_owner
    if (!((@list && @list.owner?(@current_user)) || (@item && @item.list.owner?(@current_user))))
      render_error(:unauthorized, "User is not the owner", "User with id \"#{@current_user.id}\" is not the owner of this list.")
    end
  end
end
