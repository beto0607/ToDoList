require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
    #Index
    test "Index - ok" do
        createUserAndLogin
        createList
        get list_comments_url(@list.id), headers: @auth_header
        assert_response :ok
    end
    test "Index - User must be the owner of the list" do
        createUserAndLogin
        createList
        createOtherUserAndLogin
        get list_comments_url(@list.id), headers:@other_user_auth_header
        assert_response :unauthorized
    end
    test "Index - list not found" do
        createUserAndLogin
        get list_comments_url(-1), headers: @auth_header
        assert_response :not_found
    end
    #End index
    #Create
    test "Create - created" do
        createUserAndLogin
        createList
        @params = attributes_for(:comment)
        post list_comments_url(@list.id), params:{comment: @params}, headers: @auth_header
        assert_response :created
    end
    test "Create - List not found" do
        createUserAndLogin
        @params = attributes_for(:comment)
        post list_comments_url(-1), params:{comment: @params}, headers: @auth_header
        assert_response :not_found
    end
    test "Create - User not logged in" do
        @user = create(:user)
        createList
        @params = attributes_for(:comment)
        post list_comments_url(@list.id), params:{comment: @params}
        assert_response :unauthorized
    end
    test "Create - User must be the owner of the list" do
        createUserAndLogin
        createList
        createOtherUserAndLogin
        @params = attributes_for(:comment)
        post list_comments_url(@list.id), params:{comment: @params}, headers:@other_user_auth_header
        assert_response :unauthorized
    end
    test "Create - Comment must have a description" do
        createUserAndLogin
        createList
        @params = attributes_for(:comment, description: nil)
        post list_comments_url(@list.id), params:{comment: @params}, headers:@auth_header
        assert_response :unprocessable_entity
    end
    #End create
    #Update
    test "Update - no content" do
        createUserAndLogin
        createComment
        put comment_url(@comment), params:{comment:{description: "new description"}}, headers: @auth_header
        assert_response :no_content
    end
    test "Update - Comment not found" do
        createUserAndLogin
        put comment_url(-1), params:{comment:{description: "new description"}}, headers: @auth_header
        assert_response :not_found
    end
    test "Update - User not logged in" do
        createUserAndLogin
        createComment
        put comment_url(@comment), params:{comment:{description: "new description"}}
        assert_response :unauthorized
    end
    test "Update - User must be the owner of the list" do
        createUserAndLogin
        createComment
        createOtherUserAndLogin
        put comment_url(@comment), params:{comment:{description: "new description"}}, headers: @other_user_auth_header
        assert_response :unauthorized
    end
    test "Update - Comment must have a description" do
        createUserAndLogin
        createComment
        put comment_url(@comment), params:{comment:{description:nil}}, headers: @auth_header
        assert_response :unprocessable_entity
    end
    #End update
    #Delete
    test "Delete - no content" do
        createUserAndLogin
        createComment
        delete comment_url(@comment), headers: @auth_header
        assert_response :no_content
    end
    test "Delete - Comment not found" do
        createUserAndLogin
        delete comment_url(-1), headers: @auth_header
        assert_response :not_found
    end
    test "Delete - User not logged in" do
        createUserAndLogin
        createComment
        delete comment_url(@comment)
        assert_response :unauthorized
    end
    test "Delete - User must be the owner of the list" do
        createUserAndLogin
        createOtherUserAndLogin
        createComment
        delete comment_url(@comment), headers: @other_user_auth_header
        assert_response :unauthorized
    end
    #End delete
    private
    def createComment
        @user || = create(:user)
        @list ||= create(:list, user_id: @user.id)
        @comment = create(:comment, list_id: @list.id)
    end
    def createList
        @user || = create(:user)
        @list = create(:list, user_id: @user.id)
    end
end
