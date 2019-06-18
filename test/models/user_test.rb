require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "Should create user" do
    assert build(:user).valid?
  end
  test "Shouldn't create user without username" do
    assert_not build(:user, username:nil).valid?
  end
  test "Shouldn't create user without email" do
    assert_not build(:user, email:nil).valid?
  end
  test "Shouldn't create user without password" do
    assert_not build(:user, password:nil).valid?
  end
  test "Shouldn't create user - duplicated email" do
    user_one = create(:user)
    assert_not build(:user, email:user_one.email).valid?
  end
  test "Shouldn't create user - duplicated username" do
    user_one = create(:user)
    assert_not build(:user, username:user_one.username).valid?
  end
  test "Shouldn't create user with a short password" do
    assert_not build(:user, password:"few").valid?
  end
  test "Shouldn't create user malformed email" do
    assert_not build(:user, email:"an_email").valid?
  end
end
