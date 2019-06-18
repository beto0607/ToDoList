require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
    #User list
    test "Users list - ok" do
        get users_url, headers: getUserTokenHeader
        assert_response :ok
    end
    test "Users list - It must be authenticated" do
        get users_url
        assert_response :unauthorized
    end
    #End user list
    #User info
    test "User info - ok by id" do
        @user = create(:user)
        get user_url(@user), headers: getUserTokenHeader
        assert_response :ok
    end
    test "User info - It must be authenticated" do
        @user = create(:user)
        get user_url(@user)
        assert_response :unauthorized
    end
    test "User info - not found" do
        get user_url(-1), headers: getUserTokenHeader
        assert_response :not_found
    end
    #End user info
    #User creation
    test "User creation - :created" do
        post users_url, params:{user: attributes_for(:user)}
        assert_response :created
    end
    test "User creation - email duplicated" do
        user = create(:user)
        post users_url, params:{user: attributes_for(:user, email:user.email)}
        assert_response :unprocessable_entity
    end
    test "User creation - username duplicated" do
        user = create(:user)
        post users_url, params:{user: attributes_for(:user, username:user.username)}
        assert_response :unprocessable_entity
    end
    test "User creation - username missing" do
        post users_url, params:{user: attributes_for(:user, username:nil)}
        assert_response :unprocessable_entity
    end
    test "User creation - email missing" do
        post users_url, params:{user: attributes_for(:user, email:nil)}
        assert_response :unprocessable_entity
    end
    test "User creation - email invalid" do
        post users_url, params:{user: attributes_for(:user, email:"an_email")}
        assert_response :unprocessable_entity
    end
    test "User creation - password missing" do
        post users_url, params:{user: attributes_for(:user, password:nil)}
        assert_response :unprocessable_entity
    end
    test "User creation - password too short" do
        post users_url, params:{user: attributes_for(:user, password:"short", password_confirmation:"short")}
        assert_response :unprocessable_entity
    end
    test "User creation - password and password_confirmation are diferent" do
        post users_url, params:{user: attributes_for(:user, password:"valid_password", password_confirmation: "Another_valid_password")}
        assert_response :unprocessable_entity
    end
    #End user creation
    #User update
    test "User update - :ok" do
        @user = create(:user)
        put user_url(@user), params:{user: {name: 'new name'}}, headers: getUserTokenHeader
        assert_response :no_content
    end
    test "User update - password" do
        @user = create(:user)
        put user_url(@user), params:{user: {password: 'new_password'}}, headers: getUserTokenHeader
        assert_response :no_content
    end
    test "User update - password and password_confirmation are diferent" do
        @user = create(:user)
        put user_url(@user), params:{user: {password: 'new_password', password_confirmation:"other_password"}}, headers: getUserTokenHeader
        assert_response :unprocessable_entity
    end
    test "User update - user should be logged in" do
        @user = create(:user)
        put user_url(@user), params:{user: {name: 'new name'}}
        assert_response :unauthorized
    end
    test "User update - user not found" do
        @user = create(:user)
        put user_url(-1), params:{user: {name: 'new name'}}, headers: getUserTokenHeader
        assert_response :not_found
    end
    test "User update - username duplicated" do
        @user = create(:user)
        @user2 = create(:user)
        put user_url(@user), params:{user: {username: @user2.username}}, headers: getUserTokenHeader
        assert_response :unprocessable_entity
    end
    test "User update - email duplicated" do
        @user = create(:user)
        @user2 = create(:user)        
        put user_url(@user), params:{user: {email: @user2.email}}, headers: getUserTokenHeader
        assert_response :unprocessable_entity
    end
    #End user update
    #User deletion
    test "User delete - ok" do
        @user = create(:user)
        delete user_url(@user), headers: getUserTokenHeader
        assert_response :no_content
    end
    test "User delete - should be logged in" do
        @user = create(:user)
        delete user_url(@user)
        assert_response :unauthorized
    end
    #End user deletion
    private 
    def getUserTokenHeader
        @user ||= create(:user)
        {Authorization: "Bearer #{JsonWebToken.encode(user_id: @user.id)}"}
    end
end
