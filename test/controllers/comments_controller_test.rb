require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
    #Comment index
    test "Index comment - ok" do
        @comment = create(:comment)
        get list_comments_url(@comment.list_id)
        assert_response :ok
    end
    test "Index comment - list not found" do
        get list_comments_url(-1)
        assert_response :not_found
    end
    #End comment index
    #Comment index

    private
    def createUserAndLogin
        @user ||= create(:user)
        @auth_header = {Authorization: "Bearer #{JsonWebToken.encode(user_id: @user.id)}"}
    end
#     test "should get index" do
#     get comments_url, as: :json
#     assert_response :success
#   end

#   test "should create comment" do
#     assert_difference('Comment.count') do
#       post comments_url, params: { comment: { description: @comment.description, user_id: @comment.user_id } }, as: :json
#     end

#     assert_response 201
#   end

#   test "should show comment" do
#     get comment_url(@comment), as: :json
#     assert_response :success
#   end

#   test "should update comment" do
#     patch comment_url(@comment), params: { comment: { description: @comment.description, user_id: @comment.user_id } }, as: :json
#     assert_response 200
#   end

#   test "should destroy comment" do
#     assert_difference('Comment.count', -1) do
#       delete comment_url(@comment), as: :json
#     end

#     assert_response 204
#   end
end
