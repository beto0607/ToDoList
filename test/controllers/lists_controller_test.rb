require "test_helper"

# Imported from test_helper:
# createUserAndLogin
#   it creates @user and @auth_header
# createOtherUserAndLogin
#   it creates @other_user and @other_user_auth_header

class ListsControllerTest < ActionDispatch::IntegrationTest
  #Index
  test "Index - With user's id" do
    createUserAndLogin
    get user_lists_url(@user.id), 
        headers: @auth_header
    assert_response :ok
  end
  test "Index - User should be logged in" do
    @user = create(:user)
    get user_lists_url(@user.id)
    assert_response :unauthorized
  end
  test "Index - User not found" do
    createUserAndLogin
    get user_lists_url(-1), 
        headers: @auth_header
    assert_response :not_found
end
#End index
#Show
test "Show - Ok" do
    createUserAndLogin
    createList
    get list_url(@list), 
        headers: @auth_header
    assert_response :ok
  end
  test "Show - not found" do
    createUserAndLogin
    get list_url(-1), 
        headers: @auth_header
    assert_response :not_found
  end
  test "Show - User should be logged in" do
    @user = create(:user)
    createList
    get list_url(@list)
    assert_response :unauthorized
  end
  #End show
  #Create
  test "Create - Created" do
    createUserAndLogin
    createList
    post user_lists_url(@user.id),
         params: { list: attributes_for(:list) },
         headers: @auth_header
    assert_response :created
  end
  test "Create - User should be logged in" do
    @user = create(:user)
    post user_lists_url(@user.id),
         params: { list: attributes_for(:list) }
    assert_response :unauthorized
  end
  test "Create - List should have a title" do
    createUserAndLogin
    post user_lists_url(@user.id),
         params: { list: attributes_for(:list, title: nil) },
         headers: @auth_header
    assert_response :unprocessable_entity
  end
  test "Create - User's ID and token should match" do
    @user = create(:user)
    createOtherUserAndLogin
    post user_lists_url(@user.id),
         params: { list: attributes_for(:list) },
         headers: @other_user_auth_header
    assert_response :unauthorized
  end
  #End create
  #Update
  test "Update - No content" do
    createUserAndLogin
    createList
    put list_url(@list), 
        params: { list: { title: "new title" } }, 
        headers: @auth_header
    assert_response :ok
  end
  test "Update - List should have a title" do
    createUserAndLogin
    createList
    put list_url(@list), 
        params: { list: { title: nil } }, 
        headers: @auth_header
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
