require 'test_helper'

# Imported from test_helper:
# createUserAndLogin
#   it creates @user and @auth_header
# createOtherUserAndLogin
#   it creates @other_user and @other_user_auth_header

class ItemsControllerTest < ActionDispatch::IntegrationTest
    #Index
    test "Index - Ok" do
        createUserAndLogin
        @list = create(:list, user_id: @user.id)
        get list_items_url(@list.id), 
            headers: @auth_header
        assert_response :ok
    end
    test "Index - List not found" do
        createUserAndLogin
        get list_items_url(-1), 
            headers: @auth_header
        assert_response :not_found
    end
    test "Index - User should be the owner of the list" do
        createUserAndLogin
        @list = create(:list, user_id: @user.id)
        createOtherUserAndLogin
        get list_items_url(@list.id), 
            headers: @other_user_auth_header
        assert_response :unauthorized
    end
    test "Index - User must be logged in" do
        @list = create(:list)
        get list_items_url(@list.id)
        assert_response :unauthorized
    end
    #End index
    #Create
    test "Create - Created" do
        createUserAndLogin
        @list = create(:list, user_id: @user.id)
        post list_items_url(@list.id), 
            params: {item: attributes_for(:item)},
            headers: @auth_header
        assert_response :created
    end
    test "Create - Item should have a title" do
        createUserAndLogin
        @list = create(:list, user_id: @user.id)
        post list_items_url(@list.id), 
            params: {item: attributes_for(:item, title: nil)},
            headers: @auth_header
        assert_response :unprocessable_entity
    end
    test "Create - User should be the owner of the list" do
        createUserAndLogin
        @list = create(:list, user_id: @user.id)
        createOtherUserAndLogin
        post list_items_url(@list.id), 
            params: {item: attributes_for(:item)},
            headers: @other_user_auth_header
        assert_response :unauthorized
    end
    test "Create - User must be logged in" do
        @list = create(:list)
        post list_items_url(@list.id), 
            params: {item: attributes_for(:item)}
        assert_response :unauthorized
    end
    test "Create - List not found" do
        createUserAndLogin
        post list_items_url(-1), 
            params: {item: attributes_for(:item)},
            headers: @auth_header
        assert_response :not_found
    end
    #End create
    #Update
    test "Update - Not content" do
        createUserAndLogin
        @list = create(:list, user_id: @user.id)
        @item = create(:item, list_id: @list.id)
        put item_url(@item.id), 
            params: {item:{title: "new title"}},
            headers: @auth_header
        assert_response :ok
    end
    test "Update - Item should have a title" do
        createUserAndLogin
        @list = create(:list, user_id: @user.id)
        @item = create(:item, list_id: @list.id)
        put item_url(@item.id),  
            params: {item:{title: nil}},
            headers: @auth_header
        assert_response :unprocessable_entity
    end
    test "Update - User must be the owner of the list" do
        createUserAndLogin
        @list = create(:list, user_id: @user.id)
        @item = create(:item, list_id: @list.id)
        createOtherUserAndLogin
        put item_url(@item.id), 
            params: {item:{title: "new title"}},
            headers: @other_user_auth_header
        assert_response :unauthorized
    end
    test "Update - User must be logged in" do
        @list = create(:list)
        @item = create(:item, list_id: @list.id)
        put item_url(@item.id), 
            params: {item:{title: "new title"}}
        assert_response :unauthorized
    end
    test "Update - Comment not found" do
        createUserAndLogin
        @list = create(:list, user_id: @user.id)
        @item = create(:item, list_id: @list.id)
        put item_url(-1), 
            params: {item:{title: "new title"}},
            headers: @auth_header
        assert_response :not_found
    end
    #End update
    #Resolve
    test "Resolve - Ok" do
        createUserAndLogin
        @list = create(:list, user_id: @user.id)
        @item = create(:item, list_id: @list.id)
        put resolve_url(@item), 
            headers: @auth_header
        assert_response :ok
        assert_equal "DONE", response.parsed_body["item"]["status"]
    end
    test "Resolve - Item not found" do
        createUserAndLogin
        put resolve_url(-1), 
            headers: @auth_header
        assert_response :not_found
    end
    test "Resolve - User must be the owner of the list" do
        @list = create(:list)
        @item = create(:item, list_id: @list.id)
        createOtherUserAndLogin
        put resolve_url(@item), 
            headers: @other_user_auth_header
        assert_response :unauthorized
    end
    test "Resolve - User must be logged in" do
        @list = create(:list)
        @item = create(:item, list_id: @list.id)
        put resolve_url(@item)
        assert_response :unauthorized
    end
    #End resolve
    #Unsolve
    test "Unsolve - Ok" do
        createUserAndLogin
        @list = create(:list, user_id: @user.id)
        @item = create(:item, list_id: @list.id)
        put unsolve_url(@item), 
            headers: @auth_header
        assert_response :ok
        assert_equal "ACTIVE", response.parsed_body["item"]["status"]
    end
    test "Unsolve - Item not found" do
        createUserAndLogin
        put unsolve_url(-1), 
            headers: @auth_header
        assert_response :not_found
    end
    test "Unsolve - User must be the owner of the list" do
        @list = create(:list)
        @item = create(:item, list_id: @list.id)
        createOtherUserAndLogin
        put unsolve_url(@item), 
            headers: @other_user_auth_header
        assert_response :unauthorized
    end
    test "Unsolve - User must be logged in" do
        @list = create(:list)
        @item = create(:item, list_id: @list.id)
        put unsolve_url(@item)
        assert_response :unauthorized
    end
    #End unsolve
    #Delete
    test "Delete - No content" do
        createUserAndLogin
        @list = create(:list, user_id: @user.id)
        @item = create(:item, list_id: @list.id)
        delete item_url(@item.id),
            headers: @auth_header
        assert_response :no_content
    end
    test "Delete - Comment not found" do
        createUserAndLogin
        @list = create(:list, user_id: @user.id)
        @item = create(:item, list_id: @list.id)
        delete item_url(-1),
            headers: @auth_header
        assert_response :not_found
    end
    test "Delete - User must be the owner of the list" do
        createUserAndLogin
        @list = create(:list, user_id: @user.id)
        @item = create(:item, list_id: @list.id)
        createOtherUserAndLogin
        delete item_url(@item.id),
            headers: @other_user_auth_header
        assert_response :unauthorized
    end
    test "Delete - User must be logged in" do
        @list = create(:list)
        @item = create(:item, list_id: @list.id)
        delete item_url(@item.id)
        assert_response :unauthorized
    end
    #End delete
    private 
    def resolve_url item
        item_url(item)+"/resolve"
    end
    def unsolve_url item
        item_url(item)+"/unsolve"
    end
end
