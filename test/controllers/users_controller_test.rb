require 'test_helper'

# Imported from test_helper:
# createUserAndLogin
#   it creates @user and @auth_header
# createOtherUserAndLogin
#   it creates @other_user and @other_user_auth_header

class UsersControllerTest < ActionDispatch::IntegrationTest
    #Index
    test "Index - Ok" do
        createUserAndLogin
        get users_url, headers: @auth_header
        assert_response :ok
    end
    test "Index - User should be logged in" do
        get users_url
        assert_response :unauthorized
    end
    #End index
    #Show
    test "Show - Ok" do
        createUserAndLogin
        get user_url(@user), headers: @auth_header
        assert_response :ok
    end
    test "Show - User should be logged in" do
        @user = create(:user)
        get user_url(@user)
        assert_response :unauthorized
    end
    test "Show - Not found" do
        createUserAndLogin
        get user_url(-1), headers: @auth_header
        assert_response :not_found
    end
    #End show
    #Create
    test "Create - Created" do
        post users_url, params:{user: attributes_for(:user)}
        assert_response :created
    end
    test "Create - Email duplicated" do
        @user = create(:user)
        post users_url, params:{user: attributes_for(:user, email: @user.email)}
        assert_response :unprocessable_entity
    end
    test "Create - User should have an email" do
        post users_url, params:{user: attributes_for(:user, email:nil)}
        assert_response :unprocessable_entity
    end
    test "Create - Email invalid" do
        post users_url, params:{user: attributes_for(:user, email:"an_email")}
        assert_response :unprocessable_entity
    end
    test "Create - Username duplicated" do
        @user = create(:user)
        post users_url, params:{user: attributes_for(:user, username: @user.username)}
        assert_response :unprocessable_entity
    end
    test "Create - User should have an username" do
        post users_url, params:{user: attributes_for(:user, username:nil)}
        assert_response :unprocessable_entity
    end
    test "Create - User should have a password" do
        post users_url, params:{user: attributes_for(:user, password:nil)}
        assert_response :unprocessable_entity
    end
    test "Create - Password is too short" do
        post users_url, params:{user: attributes_for(:user, password:"short", password_confirmation:"short")}
        assert_response :unprocessable_entity
    end
    test "Create - Password and password_confirmation are different" do
        post users_url, params:{user: attributes_for(:user, password:"valid_password", password_confirmation: "Another_valid_password")}
        assert_response :unprocessable_entity
    end
    #End create
    #Update
    test "Update - No content" do
        createUserAndLogin
        put user_url(@user), params:{user: {name: 'new name'}}, headers: @auth_header
        assert_response :no_content
    end
    test "Update - Password" do
        createUserAndLogin
        put user_url(@user), params:{user: {password: 'new_password'}}, headers: @auth_header
        assert_response :no_content
    end
    test "Update - Password and password_confirmation are different" do
        createUserAndLogin
        put user_url(@user), params:{user: {password: 'new_password', password_confirmation:"other_password"}}, headers: @auth_header
        assert_response :unprocessable_entity
    end
    test "Update - User should be logged in" do
        @user = create(:user)
        put user_url(@user), params:{user: {name: 'new name'}}
        assert_response :unauthorized
    end
    test "Update - User's id and token should match" do
        createUserAndLogin
        createOtherUserAndLogin
        put user_url(@user), params:{user: {name: 'new name'}}, headers: @other_user_auth_header
        assert_response :unauthorized
    end
    test "Update - User not found" do
        createUserAndLogin
        put user_url(-1), params:{user: {name: 'new name'}}, headers: @auth_header
        assert_response :not_found
    end
    test "Update - Username duplicated" do
        createUserAndLogin
        @other_user = create(:user)
        put user_url(@user), params:{user: {username: @other_user.username}}, headers: @auth_header
        assert_response :unprocessable_entity
    end
    test "Update - Email duplicated" do
        createUserAndLogin
        @other_user = create(:user)
        put user_url(@user), params:{user: {email: @other_user.email}}, headers: @auth_header
        assert_response :unprocessable_entity
    end
    test "Update - User should have an username" do
        createUserAndLogin
        put user_url(@user), params:{user: {username: nil}}, headers: @auth_header
        assert_response :unprocessable_entity
    end
    test "Update - User should have an email" do
        createUserAndLogin
        put user_url(@user), params:{user: {email: nil}}, headers: @auth_header
        assert_response :unprocessable_entity
    end
    #End update
    #Delete
    test "Delete - No content" do
        createUserAndLogin
        delete user_url(@user), headers: @auth_header
        assert_response :no_content
    end
    test "Delete - User should be logged in" do
        @user = create(:user)
        delete user_url(@user)
        assert_response :unauthorized
    end
    test "Delete - User's id and token should match" do
        createUserAndLogin
        createOtherUserAndLogin
        delete user_url(@user), headers: @other_user_auth_header
        assert_response :unauthorized
    end
    test "Delete - No content - Should destroy lists if any" do
        createUserAndLogin
        @list = create(:list, user: @user)
        delete user_url(@user), headers: @auth_header
        assert_response :no_content
        assert_equal @user.lists.count, 0
    end
    #End delete
end
