require "test_helper"

# Imported from test_helper:
# createUserAndLogin
#   it creates @user and @auth_header
# createOtherUserAndLogin
#   it creates @other_user and @other_user_auth_header

class ListsControllerTest < ActionDispatch::IntegrationTest
  #Index
  test "Index - ok" do
    get lists_url
    assert_response :ok
  end
  test "Index - for an user" do
    @user = create(:user)
    get "/users/#{@user.id}/lists"
    assert_response :ok
  end
  test "Index - for an user - user not found" do
    get user_lists_url(-1)
    assert_response :not_found
  end
  #End index
  #Show
  test "Show - ok" do
    createList
    get list_url(@list)
    assert_response :ok
  end
  test "Show - not found" do
    get list_url(-1)
    assert_response :not_found
  end
  #End show
  #Create
  test "Create - created" do
    createUserAndLogin
    createList
    post user_lists_url(@user), params: { list: attributes_for(:list) }, headers: @auth_header
    assert_response :created
  end
  test "Create - It should be authenticated" do
    @user = create(:user)
    post user_lists_url(@user), params: { list: attributes_for(:list) }
    assert_response :unauthorized
  end
  test "Create - It should has a title" do
    createUserAndLogin
    post user_lists_url(@user), params: { list: attributes_for(:list, title: nil) }, headers: @auth_header
    assert_response :unprocessable_entity
  end
  #End create
  #Update
  test "Update - ok" do
    createUserAndLogin
    createList
    put list_url(@list), params: { list: { title: "new title" } }, headers: @auth_header
    assert_response :ok
  end
  test "Update - It should has a title" do
    createUserAndLogin
    createList
    put list_url(@list), params: { list: { title: nil } }, headers: @auth_header
    assert_response :unprocessable_entity
  end
  test "Update - User should be logged in" do
    @user = create(:user)
    createList
    put list_url(@list), params: { list: { title: "new title" } }
    assert_response :unauthorized
  end
  test "Update - User should be the owner" do
    createUserAndLogin
    createList
    createOtherUserAndLogin
    put list_url(@list), params: { list: { title: "new title" } }, headers: @other_user_auth_header
    assert_response :unauthorized
  end
  #End update
  #Delete
  test "Delete - ok" do
    createUserAndLogin
    createList
    delete list_url(@list), headers: @auth_header
    assert_response :no_content
  end
  test "Delete - User should be logged in" do
    @user = create(:user)
    createList
    delete list_url(@list)
    assert_response :unauthorized
  end
  test "Delete - User should be the owner" do
    @user = create(:user)
    createList
    createOtherUserAndLogin
    delete list_url(@list), headers: @other_user_auth_header
    assert_response :unauthorized
  end
  test "Delete - remove items" do
    createUserAndLogin
    createList
    createItem
    delete list_url(@list), headers: @auth_header
    assert_response :no_content
    assert_equal @list.items.count, 0
  end
  #End delete
  private

  def createList
    @user ||= create(:user)
    @list = create(:list, user: @user)
  end

  def createItem
    @item = create(:item, list: @list)
  end
end
