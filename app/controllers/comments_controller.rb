class CommentsController < ApplicationController
  before_action :authorize_request
  before_action :set_list, only: [:index, :create]
  before_action :set_comment, only: [:show, :update, :destroy]
  before_action :check_if_owner, only: [:index, :create, :update, :destroy]

  # GET /lists/1/comments
  def index
    render json: serialize_models(@list.comments),
           status: :ok
  end

  # POST /lists/1/comments
  def create
    @comment = Comment.new(comment_params)
    @comment.user = @current_user
    @comment.list = @list
    if @comment.save
      render json: serialize_model(@comment),
             status: :created
    else
      render_errors(:unprocessable_entity, @comment.errors)
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      render json: serialize_model(@comment),
             status: :ok
    else
      render_errors(:unprocessable_entity, @comment.errors)
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_error(:not_found, "Comment not found", "Comment with id \"#{params[:id]}\" was not found.")
  end

  # Only allow a trusted parameter "white list" through.
  def comment_params
    params.require(:comment).permit(:description)
  end

  def set_list
    @list = List.find(params[:list_id])
  rescue ActiveRecord::RecordNotFound
    render_error(:not_found, "List not found", "List with id \"#{params[:list_id]}\" was not found.")
  end

  def check_if_owner
    if ((@comment && List.find(@comment.list_id).owner?(@current_user)) || (@list && @list.owner?(@current_user)))
      true
    else
      render_error(:unauthorized, "User is not the owner", "User with id \"#{@current_user.id}\" is not the owner of this list.")
    end
  end
end
