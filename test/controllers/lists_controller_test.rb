require 'test_helper'

class ListsControllerTest < ActionDispatch::IntegrationTest
    #Lists index
    test "Index lists - ok" do
        get lists_url
        assert_response :ok
    end
    test "Index lists - for an user" do
        @user = create(:user)
        get "/users/#{@user.id}/lists"
        assert_response :ok
    end
    test "Index lists - for an user - user not found" do
        get user_lists_url(-1)
        assert_response :not_found
    end
    #End lists index
    #List show
    test "Show list - ok" do
        createList
        get list_url(@list)
        assert_response :ok
    end
    test "Show list - not found" do
        get list_url(-1)
        assert_response :not_found
    end
    #End lists show
    #List creation
    test "Create list - created" do
        createUserAndLogin
        createList
        post user_lists_url(@user), params:{list: attributes_for(:list)}, headers: @auth_header
        assert_response :created
    end
    test "Create list - It should be authenticated" do
        @user = create(:user)
        post user_lists_url(@user), params:{list: attributes_for(:list)}
        assert_response :unauthorized
    end
    test "Create list - It should has a title" do
        createUserAndLogin
        post user_lists_url(@user), params:{list: attributes_for(:list, title: nil)}, headers: @auth_header
        assert_response :unprocessable_entity
    end
    #End lists creation
    #List update
    test "Update List - ok" do
        createUserAndLogin
        createList
        put list_url(@list), params:{list:{title: "new title"}}, headers:@auth_header
        assert_response :ok
    end
    test "Update list - It should has a title" do
        createUserAndLogin
        createList
        put list_url(@list), params:{list: {title: nil}}, headers: @auth_header
        assert_response :unprocessable_entity
    end
    test "Update list - User should be logged in" do
        @user = create(:user)
        createList
        put list_url(@list), params:{list: {title: "new title"}}
        assert_response :unauthorized
    end
    test "Update list - User should be the owner" do
        createUserAndLogin
        createList
        createOtherUserAndLogin
        put list_url(@list), params:{list: {title: "new title"}}, headers: @other_user_auth_header
        assert_response :unauthorized
    end
    #End lists update
    #List delete
    test "Delete list - ok" do
        createUserAndLogin
        createList
        delete list_url(@list), headers: @auth_header
        assert_response :no_content
    end
    test "Delete list - User should be logged in" do
        @user = create(:user)
        createList
        delete list_url(@list)
        assert_response :unauthorized
    end
    test "Delete list - User should be the owner" do
        @user = create(:user)
        createList
        createOtherUserAndLogin
        delete list_url(@list), headers: @other_user_auth_header
        assert_response :unauthorized
    end
    #End lists delete

    private
    def createUserAndLogin
        @user ||= create(:user)
        @auth_header = {Authorization: "Bearer #{JsonWebToken.encode(user_id: @user.id)}"}
    end
    def createOtherUserAndLogin
        @other_user ||= create(:user)
        @other_user_auth_header = {Authorization: "Bearer #{JsonWebToken.encode(user_id: @other_user.id)}"}
    end
    def createList
        @user ||= create(:user)
        @list = create(:list, user:@user)
    end
end
