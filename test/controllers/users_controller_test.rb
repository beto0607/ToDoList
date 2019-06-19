require 'test_helper'

# Imported from test_helper:
# createUserAndLogin
#   it creates @user and @auth_header
# createOtherUserAndLogin
#   it creates @other_user and @other_user_auth_header

class UsersControllerTest < ActionDispatch::IntegrationTest
    #Index
    test "Index - ok" do
        createUserAndLogin
        get users_url, headers: @auth_header
        assert_response :ok
    end
    test "Index - It must be authenticated" do
        get users_url
        assert_response :unauthorized
    end
    #End index
    #Show
    test "Show - ok" do
        createUserAndLogin
        get user_url(@user), headers: @auth_header
        assert_response :ok
    end
    test "Show - It must be authenticated" do
        @user = create(:user)
        get user_url(@user)
        assert_response :unauthorized
    end
    test "Show - not found" do
        createUserAndLogin
        get user_url(-1), headers: @auth_header
        assert_response :not_found
    end
    #End show
    #Create
    test "Create - created" do
        post users_url, params:{user: attributes_for(:user)}
        assert_response :created
    end
    test "Create - email duplicated" do
        @user = create(:user)
        post users_url, params:{user: attributes_for(:user, email: @user.email)}
        assert_response :unprocessable_entity
    end
    test "Create - username duplicated" do
        @user = create(:user)
        post users_url, params:{user: attributes_for(:user, username: @user.username)}
        assert_response :unprocessable_entity
    end
    test "Create - username missing" do
        post users_url, params:{user: attributes_for(:user, username:nil)}
        assert_response :unprocessable_entity
    end
    test "Create - email missing" do
        post users_url, params:{user: attributes_for(:user, email:nil)}
        assert_response :unprocessable_entity
    end
    test "Create - email invalid" do
        post users_url, params:{user: attributes_for(:user, email:"an_email")}
        assert_response :unprocessable_entity
    end
    test "Create - password missing" do
        post users_url, params:{user: attributes_for(:user, password:nil)}
        assert_response :unprocessable_entity
    end
    test "Create - password too short" do
        post users_url, params:{user: attributes_for(:user, password:"short", password_confirmation:"short")}
        assert_response :unprocessable_entity
    end
    test "Create - password and password_confirmation are diferent" do
        post users_url, params:{user: attributes_for(:user, password:"valid_password", password_confirmation: "Another_valid_password")}
        assert_response :unprocessable_entity
    end
    #End create
    #Update
    test "Update - :ok" do
        createUserAndLogin
        put user_url(@user), params:{user: {name: 'new name'}}, headers: @auth_header
        assert_response :no_content
    end
    test "Update - password" do
        createUserAndLogin
        put user_url(@user), params:{user: {password: 'new_password'}}, headers: @auth_header
        assert_response :no_content
    end
    test "Update - password and password_confirmation are different" do
        createUserAndLogin
        put user_url(@user), params:{user: {password: 'new_password', password_confirmation:"other_password"}}, headers: @auth_header
        assert_response :unprocessable_entity
    end
    test "Update - user should be logged in" do
        @user = create(:user)
        put user_url(@user), params:{user: {name: 'new name'}}
        assert_response :unauthorized
    end
    test "Update - an user only can update himself" do
        createUserAndLogin
        createOtherUserAndLogin
        put user_url(@user), params:{user: {name: 'new name'}}, headers: @other_user_auth_header
        assert_response :unauthorized
    end
    test "Update - user not found" do
        createUserAndLogin
        put user_url(-1), params:{user: {name: 'new name'}}, headers: @auth_header
        assert_response :not_found
    end
    test "Update - username duplicated" do
        createUserAndLogin
        createOtherUserAndLogin
        put user_url(@user), params:{user: {username: @other_user.username}}, headers: @auth_header
        assert_response :unprocessable_entity
    end
    test "Update - email duplicated" do
        createUserAndLogin
        createOtherUserAndLogin
        put user_url(@user), params:{user: {email: @other_user.email}}, headers: @auth_header
        assert_response :unprocessable_entity
    end
    #End update
    #Delete
    test "Delete - ok" do
        createUserAndLogin
        delete user_url(@user), headers: @auth_header
        assert_response :no_content
    end
    test "Delete - should be logged in" do
        @user = create(:user)
        delete user_url(@user)
        assert_response :unauthorized
    end
    test "Delete - an user only can destroy himself" do
        createUserAndLogin
        createOtherUserAndLogin
        delete user_url(@user), headers: @other_user_auth_header
        assert_response :unauthorized
    end
    test "Delete - should destroy lists" do
        createUserAndLogin
        @list = create(:list, user: @user)
        delete user_url(@user), headers: @auth_header
        assert_response :no_content
        assert_equal @user.lists.count, 0
    end
    #End delete
end
